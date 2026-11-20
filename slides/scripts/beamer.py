"""Build editable Beamer source and PDF from the research Markdown contract."""
import hashlib
import re
from pathlib import Path
import shutil
import subprocess
import tempfile

import pymupdf
from PIL import Image

from markdown_to_typst import plain, asset_path, standalone_image

THEMES = {'moloch': 'moloch', 'arguelles': 'Arguelles'}
VERSIONS = {'moloch': '2.3.1', 'arguelles': '2.6.0'}
ESCAPES = dict(zip('\\{}%&#_$^~', [
    r'\textbackslash{}', r'\{', r'\}', r'\%', r'\&', r'\#', r'\_', r'\$',
    r'\textasciicircum{}', r'\textasciitilde{}']))
MATH_TEXT = {'≥': r'\geq', '≤': r'\leq', '−': '-', '½': '1/2', '¼': '1/4', '⅛': '1/8'}


def escape(value):
    return ''.join(ESCAPES.get(c, c) for c in value)


class Writer:
    def __init__(self, source, project, directory, theme):
        self.source = source
        self.project = project
        self.directory = directory
        self.theme = theme

    def figure(self, node, height):
        path = asset_path(self.source, self.project, node.attrGet('src'))
        name = hashlib.sha256(path.read_bytes()).hexdigest()[:20]
        suffix = path.suffix.lower()
        if suffix == '.svg':
            target = self.directory / (name + '.pdf')
            with pymupdf.open(path) as doc:
                target.write_bytes(doc.convert_to_pdf())
        elif suffix == '.webp':
            target = self.directory / (name + '.png')
            with Image.open(path) as img:
                img.save(target)
        elif suffix in ('.png', '.jpg', '.jpeg', '.pdf'):
            target = self.directory / (name + suffix)
            shutil.copyfile(path, target)
        else:
            raise ValueError(f'Unsupported Beamer image: {path.name}')
        graphic = rf'\includegraphics[width=\linewidth,height={height:.4f}\paperheight,keepaspectratio]{{{target.name}}}'
        caption = plain(node)
        caption_tex = r'{\slideSize{14}{18} ' + escape(caption) + r'\par}' if caption else ''
        return r'{\centering ' + graphic + r'\par' + caption_tex + '}'

    def table(self, node, height, options):
        header = node.children[0].children[0].children
        rows = node.children[1].children if len(node.children) > 1 else []
        widths = options.get('widths', [1] * len(header))
        if len(widths) != len(header) or min(widths) <= 0:
            raise ValueError('Table widths must give one positive weight per column.')
        columns = ''.join(rf'>{{\hsize={w * len(header) / sum(widths):.5f}\hsize'
                          r'\linewidth=\hsize\raggedright\arraybackslash}X' for w in widths)
        means = {}
        if options.get('relative_heatmap'):
            for i, row in enumerate(rows):
                for j, cell in enumerate(row.children):
                    match = re.fullmatch(r'(\d+(?:\.\d+)?)\s*±\s*\d+(?:\.\d+)?', plain(cell))
                    if match:
                        means[i, j] = float(match[1])
        lines = [' & '.join(self.node(cell, height) for cell in header) + r'\\', r'\midrule']
        for i, row in enumerate(rows):
            cells = []
            for j, cell in enumerate(row.children):
                value = self.node(cell, height)
                if (i, j) in means:
                    low, high = min(means.values()), max(means.values())
                    weight = 50 * (means[i, j] - low) / (high - low) if high > low else 25
                    value = rf'\cellcolor{{scorefill!{weight:.2f}!white}}' + value
                cells.append(value)
            lines.append(' & '.join(cells) + r'\\')
        return (r'{\slideSize{17}{22}\setlength{\tabcolsep}{3pt}\noindent\begin{tabularx}{\linewidth}{@{}' +
                columns + r'@{}}\toprule ' + '\n'.join(lines) + '\n' + r'\bottomrule\end{tabularx}\par\smallskip}')

    def node(self, node, height):
        kind = node.type
        if kind == 'image':
            return self.figure(node, height)
        if kind == 'text':
            return ''.join(r'\ensuremath{' + MATH_TEXT[c] + '}' if c in MATH_TEXT else escape(c)
                           for c in node.content)
        if kind == 'table':
            return self.table(node, height, {})
        if kind in ('fence', 'code_block', 'code_inline'):
            if kind == 'fence' and node.info.strip() == 'typst-math':
                import pypandoc
                latex = pypandoc.convert_text('$ ' + node.content.strip() + ' $', 'latex',
                                              format='typst', extra_args=['--fail-if-warnings'])
                if not latex.strip().startswith(r'\[') or not latex.strip().endswith(r'\]'):
                    raise ValueError('Cannot convert typst-math to a display equation: ' + node.content)
                return latex.strip()
            if kind == 'fence' and node.info.strip() == 'latex-math':
                return r'\[' + node.content.strip() + r'\]'
            lines = node.content.rstrip('\n').split('\n')
            return r'\texttt{' + r'\\'.join(escape(line).replace(' ', r'\ ') for line in lines) + '}'
        children = [self.node(child, height) for child in node.children]
        body = ''.join(children)
        if kind == 'th':
            return r'{\slideMedium ' + body + '}'
        if kind in ('inline', 'td'):
            return body
        if kind == 'paragraph':
            inline = node.children[0].children
            if len(inline) == 1 and inline[0].type == 'link' and inline[0].attrGet('href').startswith('#'):
                link = inline[0]
                return (r'\hyperlink{' + escape(link.attrGet('href')[1:]) + r'}{\beamergotobutton{' +
                        escape(plain(link)) + r'}}\par')
            return body + '\\par\n'
        if kind == 'softbreak':
            return ' '
        if kind == 'hardbreak':
            return r'\\'
        if kind in ('strong', 'heading', 'em'):
            if kind == 'heading':
                return r'{\slideMedium\slideSize{22}{27} ' + body + r'\par}'
            formatted = ('\\emph{' if kind == 'em' else '\\textbf{') + body + '}'
            return formatted
        if kind == 'link':
            url = node.attrGet('href')
            if url.startswith('#'):
                return r'\hyperlink{' + escape(url[1:]) + '}{' + body + '}'
            return r'\href{' + escape(url) + '}{' + body + '}'
        if kind == 'hr':
            return r'\par\noindent\rule{\linewidth}{0.4pt}\par'
        if kind in ('bullet_list', 'ordered_list', 'blockquote'):
            env = {'bullet_list': 'itemize', 'ordered_list': 'enumerate', 'blockquote': 'quote'}[kind]
            return f'\\begin{{{env}}}\n{body}\\end{{{env}}}\n'
        if kind == 'list_item':
            return '\\item ' + body + '\n'
        raise ValueError(f'Unsupported Markdown element: {kind}')

    def frame(self, slide):
        body, options = slide['body'], slide['options']
        solo = len(body) == 1 and standalone_image(body[0]) is not None
        height = options.get('image_height', 308 if solo else 200) / 405
        first_table = next((node for node in body if node.type == 'table'), None)

        def blocks(nodes):
            return '\n\n'.join(self.table(node, height, options) if node is first_table
                               else self.node(node, height) for node in nodes)

        mode = options.get('layout', 'auto')
        groups = slide['groups']
        if mode == 'auto' and slide.get('heading') and len(body) > 1 and standalone_image(body[0]) is not None:
            groups = [body[:1], body[1:]]
        if len(groups) == 2:
            left, right = options.get('columns', [1, 1] if mode == 'columns' else [1.55, 1])
            widths = [0.96 * n / (left + right) for n in (left, right)]
            content = '\n'.join(rf'\column{{{width:.6f}\textwidth}}' + '\n' + blocks(group)
                                for width, group in zip(widths, groups))
            content = '\\begin{columns}[T,onlytextwidth]\n' + content + '\n\\end{columns}'
        else:
            content = blocks(body)
        title = escape(slide['title']) if options.get('show_title', True) else ''
        if mode == 'title':
            if len(body) != 2:
                raise ValueError(f'{title}: a title slide expects a subtitle and a date.')
            return (r'{\title{' + title + '}\n' + r'\subtitle{' + escape(plain(body[0])) +
                    '}\n' + r'\date{' + escape(plain(body[1])) + '}\n' +
                    r'\begin{frame}[plain]\titlepage\end{frame}}')
        if mode == 'section' or not body:
            if self.theme == 'moloch':
                return r'\section{' + title + '}'
            return (r'{\section*{' + title + '}\n' +
                    r'\begin{frame}[plain]\centering\usebeamerfont{section title}' +
                    title + r'\end{frame}}')
        anchor = options.get('anchor')
        if anchor:
            content = r'\hypertarget{' + escape(anchor) + '}{}\n' + content
        align = ',c' if mode == 'discussion' else ''
        return rf'\begin{{frame}}[label={slide["id"]}{align}]{{{title}}}' + '\n\\par\n' + content + '\n\\end{frame}\n'


def write_tex(project, source, slides, theme, directory):
    if theme not in THEMES:
        raise ValueError(f'Unknown Beamer theme: {theme}')
    root = Path(__file__).resolve().parents[1]
    snapshot = root / 'template/beamer/themes' / f'{theme}-{VERSIONS[theme]}'
    for path in snapshot.iterdir():
        shutil.copyfile(path, directory / path.name)
    from beamer_fonts import resolve_fonts
    font_config = (root / 'template/beamer/fonts.tex').read_text(encoding='utf-8')
    for role, path in resolve_fonts(root).items():
        font_config = font_config.replace(f'@{role}File@', path.name)
        font_config = font_config.replace(f'@{role}Dir@', path.parent.as_posix() + '/')
    (directory / 'fonts.tex').write_text(font_config, encoding='utf-8')
    writer = Writer(source, project, directory, theme)
    frames = [writer.frame(slide) for slide in slides]
    preamble = [
        r'\documentclass[aspectratio=169,fontset=none]{ctexbeamer}',
        r'\usepackage{unicode-math}',
        r'\usetheme{Arguelles}' if theme == 'arguelles' else r'\usetheme{moloch}',
        r'\usepackage{tabularx,booktabs,colortbl}',
        r'\definecolor{scorefill}{HTML}{107895}',
        r'\input{fonts.tex}',
    ]
    document = '\n'.join([*preamble, r'\input{config.tex}', r'\begin{document}', *frames, r'\end{document}'])
    (directory / 'main.tex').write_text(document + '\n', encoding='utf-8')
    custom = project / 'beamer' / 'config.tex'
    if custom.is_file():
        shutil.copyfile(custom, directory / 'config.tex')
    else:
        (directory / 'config.tex').write_text('% Project overrides: beamer/config.tex\n', encoding='utf-8')


def compile_beamer(project, source, slides, theme):
    output = project / 'output'
    bundle = output / 'beamer' / theme
    bundle.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=output) as tmp:
        directory = Path(tmp)
        write_tex(project, source, slides, theme, directory)
        files = list(directory.iterdir())
        command = ['latexmk', '-norc', '-xelatex', '-interaction=nonstopmode', '-halt-on-error',
                   '-file-line-error', 'main.tex']
        run = subprocess.run(command, cwd=directory, capture_output=True)
        (bundle / 'compile.log').write_bytes(run.stdout + run.stderr)
        if run.returncode:
            raise RuntimeError(f'XeLaTeX build failed. See {bundle / "compile.log"}')
        log = (directory / 'main.log').read_text(encoding='utf-8', errors='replace')
        messages = [s for s in log.splitlines() if s.startswith(('Overfull ', 'Missing character:'))]
        if messages:
            raise RuntimeError('\n'.join(messages) + f'\nSee {bundle / "compile.log"}')
        files.append(directory / 'main.pdf')
        for path in files:
            shutil.copyfile(path, bundle / path.name)
    return (bundle / 'main.pdf').read_bytes(), [bundle / p.name for p in files]

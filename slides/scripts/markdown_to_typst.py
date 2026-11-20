"""Adapt Markdown and project assets to the existing Typst slide template."""

import json
import os
import re
from pathlib import Path
from urllib.parse import unquote, urlsplit


def quoted(value):
    return json.dumps(value, ensure_ascii=False)


def plain(node):
    return ''.join(plain(child) for child in node.children) if node.children else node.content


def standalone_image(node):
    if node.type == 'paragraph' and len(node.children[0].children) == 1:
        image = node.children[0].children[0]
        if image.type == 'image':
            return image
    return None


def asset_path(source: Path, project: Path, url: str) -> Path:
    parts = urlsplit(url)
    if parts.scheme or parts.netloc or parts.path.startswith('/'):
        raise ValueError(f'Use a project-relative image path: {url}')
    path = (source.parent / unquote(parts.path)).resolve()
    if not path.is_relative_to(project) or not path.is_file():
        raise ValueError(f'Image missing from the project: {url}')
    return path


def typst(node, source, project, entry, *, compact, image_height=None):
    def render(child):
        return typst(child, source, project, entry, compact=compact, image_height=image_height)

    children = node.children
    match node.type:
        case 'text':
            return f'#text({quoted(node.content)})' if node.content else ''
        case 'softbreak':
            return ' '
        case 'hardbreak':
            return '#linebreak()'
        case 'inline' | 'paragraph' | 'list_item' | 'th' | 'td':
            separator = '\n\n' if node.type == 'list_item' else ''
            return separator.join(map(render, children))
        case 'heading':
            return f'#strong[{render(children[0])}]'
        case 'em' | 'strong':
            return f'#{node.type}[{"".join(map(render, children))}]'
        case 'bullet_list' | 'ordered_list':
            items = ', '.join(f'[{render(item)}]' for item in children)
            if node.type == 'bullet_list':
                return f'#list({items})'
            return f'#enum(start: {node.attrGet("start") or 1}, {items})'
        case 'table':
            header = children[0].children[0].children
            rows = children[1].children if len(children) > 1 else []
            cells = ', '.join(f'[{render(cell)}]' for row in rows for cell in row.children)
            labels = ', '.join(f'[{render(cell)}]' for cell in header)
            return f'#markdown-table(({labels},), ({cells},))' if cells else f'#markdown-table(({labels},), ())'
        case 'image':
            path = asset_path(source, project, node.attrGet('src'))
            relative = Path(os.path.relpath(path, entry.parent)).as_posix()
            height = image_height if image_height is not None else (96 if compact else 308)
            label = quoted(plain(node))
            return f'#markdown-figure({quoted(relative)}, {label}, height: {height}pt)'
        case 'link':
            href = node.attrGet('href')
            return f'#link({quoted(href)})[{"".join(map(render, children))}]'
        case 'code_inline' | 'code_block' | 'fence':
            if node.type == 'fence' and node.info.strip() == 'typst-math':
                return '$ ' + node.content.strip() + ' $'
            block = 'false' if node.type == 'code_inline' else 'true'
            return f'#raw({quoted(node.content)}, block: {block})'
        case 'blockquote':
            return '#quote(block: true)[' + '\n\n'.join(map(render, children)) + ']'
        case 'hr':
            return '#line(length: 100%)'
        case _:
            raise ValueError(f'Unsupported Markdown element: {node.type}')


def clean_page(title, body, options, source, project, entry):
    """Compose this page from the selected theme's native elements."""
    mode = options.get('layout', 'auto')
    heading = f'title: [#text({quoted(title)})]' if options.get('show_title', True) else 'title: none'

    def render(node):
        if node.type == 'heading':
            return f'#subtitle[{typst(node.children[0], source, project, entry, compact=False)}]'
        if node.type == 'paragraph':
            inline = node.children[0].children
            if len(inline) == 1 and inline[0].type == 'link':
                target = inline[0].attrGet('href')
                if target.startswith('#'):
                    return f'#jump({quoted(target[1:])})[#text({quoted(plain(inline[0]))})]'
        if node.type == 'blockquote':
            return '#alert()[' + blocks(node.children) + ']'
        return typst(node, source, project, entry, compact=False)

    def blocks(nodes):
        return '\n\n'.join(map(render, nodes))

    if mode == 'title':
        if len(body) != 2:
            raise ValueError(f'{title}: give the title slide a subtitle and date.')
        return f'#title-page({heading}, subtitle: [{render(body[0])}], date: [{render(body[1])}])'
    if mode == 'section' or not body:
        if body:
            raise ValueError(f'{title}: a section divider contains only its title.')
        return f'#section-page[#text({quoted(title)})]'
    if mode == 'columns':
        dividers = [i for i, node in enumerate(body) if node.type == 'hr']
        if len(dividers) != 1 or not 0 < dividers[0] < len(body) - 1:
            raise ValueError(f'{title}: separate two columns with one --- line.')
        split = dividers[0]
        ratios = ', '.join(f'{x}fr' for x in options.get('columns', [1, 1]))
        return (f'#markdown-slide({heading})[#grid(columns: ({ratios}), gutter: 1em, '
                f'[{blocks(body[:split])}], [{blocks(body[split+1:])}])]')
    if mode in ('flow', 'discussion'):
        return f'#discussion-slide({heading})[{blocks(body)}]'
    image = standalone_image(body[0])
    if image is not None:
        rel = os.path.relpath(asset_path(source, project, image.attrGet('src')), entry.parent)
        height = options.get('image_height', 310)
        visual = f'#diagram({quoted(Path(rel).as_posix())}, height: {height}pt)'
        explanation = blocks(body[1:])
        caption = plain(image)
        notes = f'#caption[#text({quoted(caption)})]\n\n' if caption else ''
        if mode == 'figure-above':
            return f'#markdown-slide({heading})[#align(center, [{visual}])\n\n{notes}{explanation}]'
        if explanation:
            return f'#experiment-slide([{visual}], [{notes}{explanation}], {heading})'
        return f'#diagram-slide([{visual}\n\n{notes}], {heading})'
    if body[0].type == 'table':
        table = body[0]
        header = table.children[0].children[0].children
        rows = table.children[1].children if len(table.children) > 1 else []
        headers = ', '.join(f'[{render(cell)}]' for cell in header)
        heatmap = all(any(plain(cell).startswith(t) for cell in header) for t in ('T0', 'T1', 'T2'))
        relative_heatmap = heatmap and options.get('relative_heatmap', False)
        means = [float(match[1]) for row in rows for cell in row.children[1:]
                 if (match := re.fullmatch(r'(\d+(?:\.\d+)?)\s*±\s*\d+(?:\.\d+)?', plain(cell)))]
        low, high = (min(means), max(means)) if means else (0, 100)
        rendered_rows = []
        for row in rows:
            values = []
            for i, cell in enumerate(row.children):
                value = f'[{render(cell)}]'
                score = re.fullmatch(r'(\d+(?:\.\d+)?)\s*±\s*\d+(?:\.\d+)?', plain(cell))
                if heatmap and i and score:
                    color_value = float(score[1])
                    if relative_heatmap:
                        color_value = 100 * (color_value - low) / (high - low) if high > low else 50
                    value = f'#score-cell({color_value}, {value})'
                    value = '[' + value + ']'
                values.append(value)
            rendered_rows.append('(' + ', '.join(values) + ',)')
        widths = options.get('widths')
        width_arg = '' if not widths else ', widths: (' + ', '.join(f'{n}fr' for n in widths) + ',)'
        row_tuple = '(' + ', '.join(rendered_rows) + ',)' if rows else '()'
        return (f'#comparison-slide(({headers},), {row_tuple}, {heading}{width_arg}, '
                f'notes: [{blocks(body[1:])}])')
    if body[0].type == 'fence' and body[0].info.strip() == 'typst-math':
        return f'#theory-slide([{render(body[0])}], {heading}, explanation: [{blocks(body[1:])}])'
    return f'#discussion-slide({heading})[{blocks(body)}]'


def read_heading_slides(source):
    try:
        from markdown_it import MarkdownIt
        from markdown_it.tree import SyntaxTreeNode
    except ModuleNotFoundError as exc:
        raise RuntimeError('Markdown parser missing. Run setup-slides.cmd.') from exc

    parser = MarkdownIt('commonmark', {'html': False}).enable('table')
    document = SyntaxTreeNode(parser.parse(source.read_text(encoding='utf-8-sig')))
    slides = []
    for node in document.children:
        if node.type == 'heading' and node.tag == 'h2':
            slides.append((node, []))
        elif slides:
            slides[-1][1].append(node)
    if not slides:
        raise ValueError('Start each slide with a level-two Markdown heading (##).')
    return slides


def render_deck(source: Path, project: Path, entry: Path, language: str, *, theme=None, prepared=None):
    from content_spec import prepare_pages
    slides = prepare_pages(source, project, heading_based=True) if prepared is None else prepared
    typst_pages = []
    for slide in slides:
        title, body = slide['title'], slide['body']
        if theme == 'quarto-clean':
            options = slide['options']
            page = clean_page(title, body, options, source, project, entry)
            if 'anchor' in options:
                page += '\n#metadata(none)#label(' + quoted(options['anchor']) + ')'
            typst_pages.append(page)
            continue
        if not body:
            raise ValueError(f'Empty slide: {title}')
        compact = body[0].type == 'table'
        subheads = [i for i, node in enumerate(body) if node.type == 'heading' and node.tag == 'h3']
        columns = len(subheads) == 2 and subheads[0] == 0
        groups = [body[:subheads[1]], body[subheads[1]:]] if columns else [body]

        def render_typst(nodes):
            return '\n\n'.join(typst(node, source, project, entry, compact=compact) for node in nodes)

        title_arg = f'title: [{render_typst(slide["heading"].children)}]'
        pieces = [render_typst(group) for group in groups]
        if columns:
            typst_pages.append(f'#discussion-slide({title_arg})[#grid(columns: (1fr, 1fr), gutter: 32pt, '
                               f'[{pieces[0]}], [{pieces[1]}])]')
        elif compact or standalone_image(body[0]) is not None:
            typst_pages.append(f'#markdown-slide({title_arg}, compact: {str(compact).lower()})[\n{pieces[0]}\n]')
        else:
            typst_pages.append(f'#discussion-slide({title_arg})[\n{pieces[0]}\n]')

    template = Path(os.path.relpath(project / 'template.typ', entry.parent)).as_posix()
    typst_source = (f'// Generated from {source.name}. Edit the Markdown and run slides.cmd build.\n'
                    f'#import {quoted(template)}: *\n#show: research-theme.with(lang: {quoted(language)})\n\n'
                    + '\n\n'.join(typst_pages) + '\n')
    return typst_source, len(slides)

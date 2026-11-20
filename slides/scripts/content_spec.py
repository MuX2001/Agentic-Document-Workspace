"""Parse the self-contained content contract and render only selected content."""
import json
import os
from pathlib import Path
import re

from markdown_it import MarkdownIt
from markdown_it.tree import SyntaxTreeNode

from markdown_to_typst import clean_page, plain, quoted, read_heading_slides, standalone_image, typst

SECTIONS = {
    '本页目的': 'purpose', 'Purpose': 'purpose',
    '上屏内容': 'present', 'Present': 'present',
    '讲述背景': 'context', 'Context': 'context',
    '证据与约束': 'evidence', 'Evidence': 'evidence',
    '可选上屏内容': 'optional', 'Optional': 'optional',
    '待补充项': 'missing', 'Missing': 'missing',
}


def read_slides(source):
    parser = MarkdownIt('commonmark', {'html': False}).enable('table')
    document = SyntaxTreeNode(parser.parse(source.read_text(encoding='utf-8-sig')))
    slides = []
    ids = set()
    slide = None
    section = None
    for node in document.children:
        if node.type == 'heading' and node.tag == 'h2':
            match = re.fullmatch(r'(S[0-9]+)\s*·\s*(.+)', plain(node))
            if not match:
                raise ValueError('Use slide headings like ## S01 · Title.')
            slide_id, title = match.groups()
            if slide_id in ids:
                raise ValueError(f'Duplicate slide ID: {slide_id}')
            ids.add(slide_id)
            slide = {'id': slide_id, 'title': title, 'sections': {}}
            slides.append(slide)
            section = None
        elif slide is not None:
            if node.type == 'heading' and node.tag == 'h3':
                section = SECTIONS.get(plain(node))
                if section is None:
                    raise ValueError(f'{slide["id"]}: unknown section {plain(node)!r}. Use #### for on-slide subheadings.')
                if section in slide['sections']:
                    raise ValueError(f'{slide["id"]}: duplicate section {section}.')
                slide['sections'][section] = []
            elif section is None:
                raise ValueError(f'{slide["id"]}: place content under ### Present or another content section.')
            else:
                slide['sections'][section].append(node)
    if not slides:
        raise ValueError('The content document has no slides.')
    for slide in slides:
        if not slide['sections'].get('present'):
            raise ValueError(f'{slide["id"]}: Present / 上屏内容 is empty.')
    return slides


def read_layouts(project, ids):
    path = project / 'layout.json'
    layouts = json.loads(path.read_text(encoding='utf-8')) if path.exists() else {}
    if not isinstance(layouts, dict) or set(layouts) - set(ids):
        raise ValueError('layout.json must map existing slide IDs to layout options.')
    allowed = {'layout', 'columns', 'image_height', 'show_title', 'include_optional'}
    for slide_id, options in layouts.items():
        if not isinstance(options, dict) or set(options) - allowed:
            raise ValueError(f'{slide_id}: unsupported layout option.')
        if options.get('layout', 'auto') not in ('auto', 'flow', 'columns', 'discussion'):
            raise ValueError(f'{slide_id}: layout must be auto, flow, columns, or discussion.')
        for key in ('show_title', 'include_optional'):
            if key in options and type(options[key]) is not bool:
                raise ValueError(f'{slide_id}: {key} must be true or false.')
        columns = options.get('columns', [1, 1])
        if (not isinstance(columns, list) or len(columns) != 2
                or any(type(x) not in (int, float) or not 0 < x <= 20 for x in columns)):
            raise ValueError(f'{slide_id}: columns requires two positive ratios.')
        height = options.get('image_height', 260)
        if type(height) not in (int, float) or not 0 < height <= 403:
            raise ValueError(f'{slide_id}: image_height must be in (0, 403] points.')
    return layouts


def prepare_pages(source, project, *, heading_based=False):
    """Resolve visible Markdown and layout once, before selecting a writer."""
    if heading_based:
        slides = [{'id': str(i), 'title': plain(h), 'heading': h, 'sections': {'present': body}}
                  for i, (h, body) in enumerate(read_heading_slides(source), 1)]
        path = project / 'layout.json'
        by_title = json.loads(path.read_text(encoding='utf-8')) if path.is_file() else {}
        layouts = {s['id']: by_title.get(s['title'], {}) for s in slides}
    else:
        slides = read_slides(source)
        layouts = read_layouts(project, [s['id'] for s in slides])
    prepared = []
    for slide in slides:
        options = layouts.get(slide['id'], {})
        body = list(slide['sections']['present'])
        if options.get('include_optional', True):
            body.extend(slide['sections'].get('optional', []))
        mode = options.get('layout', 'auto')
        groups = [body]
        if mode == 'columns':
            separators = [i for i, node in enumerate(body) if node.type == 'hr']
            if len(separators) != 1:
                raise ValueError(f'{slide["id"]}: columns requires one --- between the two content groups.')
            split = separators[0]
            groups = [body[:split], body[split + 1:]]
            if not all(groups):
                raise ValueError(f'{slide["id"]}: both columns need content.')
        prepared.append({'id': slide['id'], 'title': slide['title'], 'heading': slide.get('heading'), 'options': options,
                         'body': body, 'groups': groups})
    return prepared


def render_content(source, project, entry, language, *, theme=None, prepared=None):
    slides = prepare_pages(source, project) if prepared is None else prepared
    ids = [slide['id'] for slide in slides]
    pages = []
    for slide in slides:
        body, options, groups = slide['body'], slide['options'], slide['groups']
        mode = options.get('layout', 'auto')
        if theme == 'quarto-clean':
            pages.append(clean_page(slide['title'], body, options, source, project, entry))
            continue
        figure_only = len(body) == 1 and standalone_image(body[0]) is not None
        height = options.get('image_height', 308 if figure_only else 200)
        pieces = [
            '\n\n'.join(typst(node, source, project, entry, compact=False, image_height=height)
                        for node in group)
            for group in groups
        ]
        title = f'#text({quoted(slide["title"])})'
        title_arg = f'title: [{title}]' if options.get('show_title', True) else 'title: none'
        if mode == 'columns':
            ratios = ', '.join(f'{x}fr' for x in options.get('columns', [1, 1]))
            content = f'#grid(columns: ({ratios}), gutter: 28pt, [{pieces[0]}], [{pieces[1]}])'
        else:
            content = pieces[0]
        function = 'discussion-slide' if mode == 'discussion' else 'markdown-slide'
        pages.append(f'// {slide["id"]}\n#{function}({title_arg})[\n{content}\n]')
    template = Path(os.path.relpath(project / 'template.typ', entry.parent)).as_posix()
    result = (f'// Generated from {source.name}. Edit Markdown or layout.json.\n'
              f'#import {quoted(template)}: *\n'
              f'#show: research-theme.with(lang: {quoted(language)})\n\n'
              + '\n\n'.join(pages) + '\n')
    return result, ids

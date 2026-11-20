"""Workspace entry point for the SeaSlides research profile."""
from __future__ import annotations

import argparse
from base64 import b64encode
from datetime import datetime, timezone
import hashlib
from html import escape
from importlib import metadata
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / 'template' / 'research-slides'
UPSTREAM = ROOT / '.agents' / 'skills' / 'seaslides-typst-slides-skill' / 'scripts'
PRESETS = {
    'quarto-clean': ('A', 'Quarto Clean | 组会、文献对比'),
    'metropolis': ('B', 'Metropolis | 标题层级更鲜明的科研汇报'),
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, payload):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def inputs(project: Path) -> dict:
    return {p.relative_to(project).as_posix(): digest(p)
            for p in sorted(project.rglob('*'))
            if p.is_file() and 'output' not in p.relative_to(project).parts
            and '__pycache__' not in p.relative_to(project).parts}


def project_info(value: str):
    project = Path(value).resolve()
    config = json.loads((project / 'deck.json').read_text(encoding='utf-8'))
    if config.get('content_format') not in (None, 'research-slides-v2'):
        raise ValueError('Unsupported content_format. Use research-slides-v2 or omit it for heading-based Markdown.')
    entry = (project / config.get('entry', 'main.typ')).resolve()
    if not entry.is_relative_to(project) or entry.suffix != '.typ':
        raise ValueError('Entry must be a Typst file inside the deck directory.')
    if not config.get('markdown_source'):
        if not entry.is_file():
            raise ValueError('The Typst entry is missing.')
        pages = config.get('expected_pages')
        if type(pages) is not int or pages < 1:
            raise ValueError('Set expected_pages in deck.json to the intended positive page count.')
    return project, config, entry


def doctor(_args):
    errors = []
    for name in ('typst', 'PyMuPDF', 'Pillow', 'PyYAML', 'markdown-it-py', 'mdurl'):
        try:
            print(f'{name}: {metadata.version(name)}')
        except metadata.PackageNotFoundError:
            errors.append(f'{name}: missing; run setup-slides.cmd')
    for file in ('typst_compiler.py', 'typst_quality_checker.py', 'validate_project.py'):
        if not (UPSTREAM / file).is_file():
            errors.append(f'SeaSlides missing: {file}; see README installation instructions')
    if not errors:
        import typst
        # Compile in memory to test both required system fonts and native math.
        probe = b'#set text(font: ("Arial", "Microsoft YaHei"))\n$ x^2 $'
        _pdf, warnings = typst.compile_with_warnings(probe)
        errors.extend(str(w) for w in warnings)
    for package, version in (('touying', '0.7.4'), ('uniwarn', '0.1.1'), ('touying-quarto-clean', '0.2.1')):
        if not (TEMPLATE / f'upstream/preview/{package}/{version}/typst.toml').is_file():
            errors.append(f'{package} source snapshot missing in template/research-slides/upstream')
    if errors:
        raise RuntimeError('\n'.join(errors))
    print('SeaSlides scripts and font probe: OK')


def preset_name(value: str) -> str:
    value = value.strip().lower()
    return next((name for name, (letter, _) in PRESETS.items() if letter.lower() == value and letter), value)


def list_presets(_args=None):
    for name, (letter, description) in PRESETS.items():
        choice = f'{letter} / {name}' if letter else name
        print(f'{choice:<26} {description}')
    print('Beamer (--backend beamer): moloch (default), arguelles')


def copy_template(project: Path, preset: str, *, copy_fonts=True):
    preset_source = TEMPLATE / 'presets' / f'{preset}.typ'
    for name in ('template.typ', 'theme.md', 'layouts.typ', 'content-format.md'):
        shutil.copy2(TEMPLATE / name, project / name)
    shutil.copy2(preset_source, project / 'preset.typ')
    packages = [('touying', '0.7.4'), ('uniwarn', '0.1.1')]
    if preset == 'quarto-clean':
        packages.append(('touying-quarto-clean', '0.2.1'))
    for package, version in packages:
        relative = Path('preview') / package / version
        shutil.copytree(TEMPLATE / 'upstream' / relative,
                        project / 'theme-packages' / relative, dirs_exist_ok=True)
    if not copy_fonts:
        return
    families = ('roboto', 'firacode') if preset == 'quarto-clean' else ('firasans',)
    for family in families:
        shutil.copytree(ROOT / 'tools/fonts' / family, project / 'fonts' / family,
                        dirs_exist_ok=True)


def new(args):
    if not re.fullmatch(r'[\w][\w.-]*', args.name) or args.name in ('.', '..'):
        raise ValueError('Use a single project name, for example 20261106-paper-discussion.')
    project = ROOT / 'projects' / args.name
    if project.exists():
        raise FileExistsError(f'Project already exists: {project}')
    preset = args.template
    beamer = getattr(args, 'backend', None) == 'beamer' or bool(getattr(args, 'beamer_theme', None))
    if preset is None and sys.stdin.isatty() and not beamer:
        list_presets()
        while preset not in PRESETS:
            try:
                preset = preset_name(input('Template [A/B] (Enter = A): ')) or 'quarto-clean'
            except EOFError as exc:
                raise ValueError('Pass --template to choose a preset.') from exc
    preset = preset or 'quarto-clean'
    project.mkdir(parents=True, exist_ok=False)
    copy_template(project, preset, copy_fonts=not beamer)
    starter = 'starter-en.md' if args.language == 'en' else 'starter.md'
    shutil.copy2(TEMPLATE / starter, project / 'slides.md')
    for folder in ('assets/videos', 'sources', 'output'):
        (project / folder).mkdir(parents=True, exist_ok=True)
    if beamer:
        (project / 'beamer').mkdir()
        (project / 'beamer/config.tex').write_text(
            '% Project font, size and color overrides, loaded after the theme.\n', encoding='utf-8')
    write_json(project / 'deck.json', {
        'profile': 'research-slides-v1', 'entry': 'main.typ',
        'markdown_source': 'slides.md', 'content_format': 'research-slides-v2',
        'language': args.language,
        'theme': preset,
        'render_adapter': 'shared-v1',
        **({'backend': 'beamer', 'beamer_theme': getattr(args, 'beamer_theme', None) or 'moloch'}
           if beamer else {}),
    })
    write_json(project / 'template-origin.json', {
        'template': 'research-slides-v1', 'template_sha256': digest(project / 'template.typ'),
        'preset': preset, 'preset_sha256': digest(project / 'preset.typ'),
        'upstream_files': {p.relative_to(project).as_posix(): digest(p)
                           for folder in ('theme-packages', 'fonts')
                           for p in sorted((project / folder).rglob('*')) if p.is_file()},
        'toolchain': json.loads((ROOT / 'tools/slides-toolchain.json').read_text()),
    })
    print(f'Created {project} ({preset})\nEdit slides.md. Run build only when rendering is requested.')


def preview(args):
    project = TEMPLATE / 'output' / 'presets' / args.template
    project.mkdir(parents=True, exist_ok=True)
    copy_template(project, args.template)
    for name in ('main.typ', 'deck.json'):
        shutil.copy2(TEMPLATE / name, project / name)
    shutil.copytree(TEMPLATE / 'assets', project / 'assets', dirs_exist_ok=True)
    build(argparse.Namespace(project=str(project)))


def inspect_pdf(project: Path, expected: int) -> list[str]:
    import pymupdf
    errors = []
    with pymupdf.open(project / 'output/slides.pdf') as pdf:
        if len(pdf) != expected:
            errors.append(f'Expected {expected} pages, found {len(pdf)}.')
        for number, page in enumerate(pdf, 1):
            if abs(page.rect.width / page.rect.height - 16 / 9) > 0.002:
                errors.append(f'Page {number}: not 16:9.')
            for block in page.get_text('dict')['blocks']:
                if block.get('type') != 0:
                    continue
                for line in block['lines']:
                    for span in line['spans']:
                        box = pymupdf.Rect(span['bbox'])
                        if not (page.rect + (-1, -1, 1, 1)).contains(box):
                            errors.append(f'Page {number}: text outside page: {span["text"][:60]}')
                        if '\ufffd' in span['text']:
                            errors.append(f'Page {number}: replacement glyph in extracted text.')
    return errors


def build(args):
    from render_slides import render
    project, config, entry = project_info(args.project)
    render(project, config, entry, args)


def export_html(project, language):
    """Package the verified PDF pages as a standalone HTML viewer."""
    import pymupdf

    pages = []
    with pymupdf.open(project / 'output/slides.pdf') as pdf:
        for number, page in enumerate(pdf, 1):
            svg = b64encode(page.get_svg_image(text_as_path=True).encode('utf-8')).decode('ascii')
            label = escape(page.get_text(), quote=True)
            pages.append(f'<img id="slide-{number}" src="data:image/svg+xml;base64,{svg}" alt="{label}">')
    html = (f'<!doctype html><html lang="{escape(language)}"><meta charset="utf-8">'
            '<meta name="viewport" content="width=device-width, initial-scale=1">'
            f'<title>{escape(project.name)}</title>'
            '<style>html{background:#eee}body{margin:0}main{max-width:1440px;margin:auto}'
            'img{display:block;width:100%;height:auto;margin-bottom:16px}'
            '@media print{@page{size:16in 9in;margin:0}img{margin:0;break-after:page}}</style>'
            '<main>' + '\n'.join(pages) + '</main></html>')
    destination = project / 'output/slides.html'
    destination.write_text(html, encoding='utf-8')
    return destination


def check(args):
    project, config, entry = project_info(args.project)
    record = json.loads((project / 'output/build.json').read_text(encoding='utf-8'))
    if record.get('status') != 'passed' or record.get('inputs') != inputs(project):
        raise RuntimeError('No successful build for current sources. Run build first.')
    if record.get('pdf_sha256') != digest(project / 'output/slides.pdf'):
        raise RuntimeError('The PDF differs from the recorded build. Rebuild before review.')
    if record.get('pipeline') != 'single-pdf':
        raise RuntimeError('Run build to generate a current render manifest.')
    manifest_path = project / 'output/compile-manifest.json'
    if digest(manifest_path) != record['manifest_sha256']:
        raise RuntimeError('The render manifest has changed. Build again.')
    manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    for name, expected_digest in manifest['artifacts'].items():
        path = (project / 'output' / name).resolve()
        if not path.is_relative_to(project / 'output') or digest(path) != expected_digest:
            raise RuntimeError(f'Rendered artifact changed: {name}')
    config['expected_pages'] = record['expected_pages']
    errors = inspect_pdf(project, config['expected_pages'])
    if errors:
        raise RuntimeError('\n'.join(errors))
    print('Source, artifact, and PDF checks passed (no compilation).')
    return project, config


def review(args):
    project, config = check(args)
    pages = list(range(1, config['expected_pages'] + 1)) if args.pages == 'all' else sorted({int(p) for p in args.pages.split(',')})
    if pages != list(range(1, config['expected_pages'] + 1)):
        raise ValueError('Record every page number after viewing all current PNGs.')
    # This command records a human/agent attestation; it does not perform visual QA.
    write_json(project / 'output/review.json', {
        'scope': 'full', 'result': 'user_approved' if args.approve else 'inspected',
        'reviewer': args.reviewer, 'pages': pages,
        'notes': args.notes, 'pdf_sha256': digest(project / 'output/slides.pdf'),
        'compile_manifest_sha256': digest(project / 'output/compile-manifest.json'),
        'reviewed_at': datetime.now(timezone.utc).isoformat(),
    })
    print('Recorded user approval for this build.' if args.approve else 'Recorded visual inspection for this build.')


def copy_asset(source: Path, destination: Path):
    destination.parent.mkdir(parents=True, exist_ok=True)
    if destination.exists():
        if digest(source) != digest(destination):
            raise FileExistsError(f'Refusing to overwrite a different asset: {destination}')
    else:
        shutil.copy2(source, destination)


def import_asset(args):
    project, _, _ = project_info(args.project)
    source = Path(args.source).resolve(strict=True)
    extension = source.suffix.lower()
    if extension not in ('.pdf', '.svg', '.png', '.jpg', '.jpeg', '.webp', '.mp4', '.excalidraw'):
        raise ValueError('Supported: PDF, SVG, PNG, JPEG, WebP, MP4, Excalidraw.')
    if extension == '.pdf':
        import pymupdf
        with pymupdf.open(source) as pdf:
            if not 1 <= args.page <= len(pdf):
                raise ValueError(f'PDF page must be in 1..{len(pdf)}.')
            vector = pdf[args.page - 1].get_svg_image(text_as_path=True).encode('utf-8')
        original = project / 'assets/originals' / source.name
        destination = project / 'assets' / f'{source.stem}-page{args.page}.svg'
        if destination.exists() and destination.read_bytes() != vector:
            raise FileExistsError(f'Refusing to overwrite: {destination}')
        copy_asset(source, original)
        destination.write_bytes(vector)
    else:
        folder = 'assets/videos' if extension == '.mp4' else 'assets'
        destination = project / folder / source.name
        copy_asset(source, destination)
    receipt = project / 'sources/assets.json'
    assets = json.loads(receipt.read_text(encoding='utf-8')) if receipt.exists() else {}
    assets[destination.relative_to(project).as_posix()] = {
        'source': str(source), 'source_sha256': digest(source),
        'pdf_page': args.page if extension == '.pdf' else None,
    }
    write_json(receipt, assets)
    print(destination.relative_to(project).as_posix())


def main():
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, 'reconfigure'):
            stream.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    sub.add_parser('doctor').set_defaults(action=doctor)
    sub.add_parser('templates', help='List available slide templates').set_defaults(action=list_presets)
    p = sub.add_parser('preview', help='Build the five-page sample with a preset')
    p.add_argument('template', type=preset_name, choices=PRESETS, help='Preset name or A/B')
    p.set_defaults(action=preview)
    p = sub.add_parser('new')
    p.add_argument('name')
    p.add_argument('--backend', choices=('typst', 'beamer'))
    p.add_argument('--beamer-theme', choices=('moloch', 'arguelles'))
    p.add_argument('--language', choices=('zh', 'en'), default='zh')
    p.add_argument('--template', type=preset_name, choices=PRESETS,
                   help='Preset name or A/B (ask in a terminal, A in scripts)')
    p.set_defaults(action=new)
    for name, action in (('build', build), ('check', check)):
        p = sub.add_parser(name)
        p.add_argument('project')
        if name == 'build':
            p.add_argument('--backend', choices=('typst', 'beamer'))
            p.add_argument('--beamer-theme', choices=('moloch', 'arguelles'))
            p.add_argument('--final', action='store_true', help='Check the full deck and export all high-resolution previews')
            p.add_argument('--pages', help='Preview only these pages, e.g. 2,3; PDF and overview always cover the deck')
        p.set_defaults(action=action)
    p = sub.add_parser('review', help='Record completed visual inspection, not an automated review')
    p.add_argument('project')
    p.add_argument('--pages', required=True, help='Inspected pages, e.g. 1,2,3')
    p.add_argument('--reviewer', required=True)
    p.add_argument('--notes', default='')
    p.add_argument('--approve', action='store_true', help='Record explicit user approval of this version')
    p.set_defaults(action=review)
    p = sub.add_parser('import-asset')
    p.add_argument('project')
    p.add_argument('source')
    p.add_argument('--page', type=int, default=1)
    p.set_defaults(action=import_asset)
    args = parser.parse_args()
    if getattr(args, 'beamer_theme', None) and getattr(args, 'backend', None) == 'typst':
        parser.error('--beamer-theme requires the Beamer backend')
    try:
        args.action(args)
    except (OSError, ValueError, RuntimeError, KeyError) as exc:
        print(f'Error: {exc}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    raise SystemExit(main())

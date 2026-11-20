"""Single-compile PDF rendering, with previews derived from that same PDF."""
import math
import os
from pathlib import Path
import re
import subprocess
import tempfile
import time

import pymupdf
from PIL import Image
import typst


def render(project, config, entry, args):
    # Import at call time so slides.py remains the sole command entry.
    import slides as cli

    started = time.perf_counter()
    output = project / 'output'
    output.mkdir(exist_ok=True)
    cli.write_json(output / 'review.json', {'result': 'pending_user_review'})
    cli.write_json(output / 'build.json', {'status': 'building'})
    before = cli.inputs(project)
    try:
        beamer_theme = getattr(args, 'beamer_theme', None)
        backend = getattr(args, 'backend', None) or ('beamer' if beamer_theme else config.get('backend', 'typst'))
        if backend not in ('typst', 'beamer'):
            raise ValueError(f'Unknown backend: {backend}')
        extra_artifacts = []
        if config.get('markdown_source'):
            # Preserve older project-specific composition; new snapshots use the
            # same content adapter with the selected native theme underneath.
            theme = config.get('theme') if config.get('render_adapter') != 'shared-v1' else None
            source = (project / config['markdown_source']).resolve()
            if not source.is_relative_to(project) or source.suffix != '.md' or not source.is_file():
                raise ValueError('markdown_source must be an existing project Markdown file.')
            from content_spec import prepare_pages, render_content
            from markdown_to_typst import render_deck
            heading_based = config.get('content_format') != 'research-slides-v2'
            prepared = prepare_pages(source, project, heading_based=heading_based)
            slide_ids = [s['id'] for s in prepared]
            config['expected_pages'] = len(prepared)
            if backend == 'typst':
                writer = render_deck if heading_based else render_content
                generated, _ = writer(source, project, entry, config['language'], theme=theme, prepared=prepared)
                entry.parent.mkdir(parents=True, exist_ok=True)
                entry.write_text(generated, encoding='utf-8')
                before[entry.relative_to(project).as_posix()] = cli.digest(entry)
        elif backend == 'beamer':
            raise ValueError('Beamer requires a Markdown project.')
        else:
            slide_ids = [str(i) for i in range(1, config['expected_pages'] + 1)]

        warnings = []
        if backend == 'beamer':
            from beamer import compile_beamer, VERSIONS
            beamer_theme = beamer_theme or config.get('beamer_theme', 'moloch')
            if beamer_theme not in VERSIONS:
                raise ValueError(f'Unknown Beamer theme: {beamer_theme}')
            pdf_bytes, extra_artifacts = compile_beamer(project, source, prepared, beamer_theme)
        else:
            fonts = project / config.get('typst_font_dir', 'fonts')
            if 'typst_font_dir' in config and not fonts.is_dir():
                raise ValueError(f'Configured Typst font directory is missing: {fonts}')
            pdf_bytes, warnings = typst.compile_with_warnings(
                str(entry), format='pdf',
                font_paths=[str(fonts if fonts.is_dir() else cli.ROOT / 'tools/fonts')],
                ignore_system_fonts=config.get('ignore_system_fonts', False),
                package_cache_path=str(project / 'theme-packages' if (project / 'theme-packages').is_dir()
                                       else project / 'upstream' if (project / 'upstream/preview').is_dir()
                                       else cli.ROOT / '.cache/typst-packages'),
            )
        messages = [str(warning) for warning in warnings]
        cli.write_json(output / 'quality.json', {'warnings': messages})
        with tempfile.TemporaryDirectory(prefix='render-', dir=output) as temporary:
            staged = Path(temporary)
            # Windows tempfile ACLs otherwise follow moved artifacts into output/.
            if os.name == 'nt':
                subprocess.run(['icacls', str(staged), '/inheritance:e'],
                               check=True, stdout=subprocess.DEVNULL)
            # inspect_pdf accepts a project containing output/slides.pdf.
            probe = staged / 'output'
            probe.mkdir()
            (probe / 'slides.pdf').write_bytes(pdf_bytes)
            errors = cli.inspect_pdf(staged, config['expected_pages'])
            errors.extend(message for message in messages if 'overflow' in message.lower())
            if errors:
                raise RuntimeError('\n'.join(errors))
            with pymupdf.open(stream=pdf_bytes, filetype='pdf') as pdf:
                selected = set(range(1, len(pdf) + 1))
                if getattr(args, 'pages', None) and not getattr(args, 'final', False):
                    selected = {int(number) for number in args.pages.split(',')}
                    if not selected or not selected <= set(range(1, len(pdf) + 1)):
                        raise ValueError('--pages must contain existing page numbers.')
                ppi = 144 if getattr(args, 'final', False) else 96
                for number in sorted(selected):
                    pdf[number - 1].get_pixmap(dpi=ppi, alpha=False).save(staged / f'slide_{number}.png')
                columns = min(3, len(pdf))
                sheet = Image.new('RGB', (columns * 480, math.ceil(len(pdf) / columns) * 278), '#dddddd')
                for index, page in enumerate(pdf):
                    scale = 464 / page.rect.width
                    pix = page.get_pixmap(matrix=pymupdf.Matrix(scale, scale), alpha=False)
                    picture = Image.frombytes('RGB', (pix.width, pix.height), pix.samples)
                    sheet.paste(picture, ((index % columns) * 480 + 8, (index // columns) * 278 + 8))
                sheet.save(staged / 'overview.png')
            if cli.inputs(project) != before:
                raise RuntimeError('Sources changed during rendering. Build again.')
            pngs = output / 'pngs'
            pngs.mkdir(exist_ok=True)
            for old in pngs.glob('slide_*.png'):
                if re.fullmatch(r'slide_\d+\.png', old.name) and old.resolve().parent == pngs.resolve():
                    old.unlink()
            os.replace(probe / 'slides.pdf', output / 'slides.pdf')
            os.replace(staged / 'overview.png', output / 'overview.png')
            for number in sorted(selected):
                os.replace(staged / f'slide_{number}.png', pngs / f'slide_{number}.png')
        artifacts = [output / 'slides.pdf', output / 'overview.png', *sorted(pngs.glob('slide_*.png'))]
        artifacts.extend(extra_artifacts)
        if config.get('markdown_source'):
            artifacts.append(cli.export_html(project, config['language']))
        cli.write_json(output / 'compile-manifest.json', {
            'pipeline': 'single-pdf', 'preview_pages': sorted(selected),
            'artifacts': {path.relative_to(output).as_posix(): cli.digest(path) for path in artifacts},
        })
        cli.write_json(output / 'build.json', {
            'status': 'passed', 'pipeline': 'single-pdf',
            'backend': backend, 'beamer_theme': beamer_theme,
            **({'theme_version': VERSIONS[beamer_theme]} if backend == 'beamer' else {}),
            'mode': 'final' if getattr(args, 'final', False) else 'draft',
            'inputs': before, 'pdf_sha256': cli.digest(output / 'slides.pdf'),
            'manifest_sha256': cli.digest(output / 'compile-manifest.json'),
            'expected_pages': config['expected_pages'], 'slide_ids': slide_ids,
            'elapsed_seconds': round(time.perf_counter() - started, 3),
            'compile_calls': 1,
        })
    except Exception as exc:
        cli.write_json(output / 'build.json', {'status': 'failed', 'error': str(exc)})
        raise
    print(f'Rendered {len(slide_ids)} pages in {time.perf_counter() - started:.2f}s (one PDF compile).')
    print(f'{output / "slides.pdf"}\nAwaiting user review.')

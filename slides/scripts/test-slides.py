"""Regression checks for stage boundaries, content selection, and single compilation."""
import argparse
import json
from pathlib import Path
import shutil
import uuid
from unittest.mock import patch

import pymupdf
import typst

import slides as cli
from content_spec import read_slides

ROOT = Path(__file__).resolve().parents[1]


def expect_failure(action):
    try:
        action()
    except (ValueError, RuntimeError, OSError):
        return
    raise AssertionError('Expected rejection')


def main(preset):
    name = 'pipeline-test-' + uuid.uuid4().hex[:10]
    project = ROOT / 'projects' / name
    try:
        with patch('typst.compile', side_effect=AssertionError('Unexpected compile')), patch(
            'typst.compile_with_warnings', side_effect=AssertionError('Unexpected compile')
        ):
            cli.new(argparse.Namespace(name=name, template=preset, language='en'))
            assert not (project / 'main.typ').exists()
            assert not list((project / 'output').iterdir())
            expect_failure(lambda: cli.new(argparse.Namespace(name=name, template=preset, language='en')))
            config = json.loads((project / 'deck.json').read_text())
            assert config['content_format'] == 'research-slides-v2'
            assert read_slides(project / 'slides.md')[0]['id'] == 'S01'
        assert (project / 'preset.typ').read_bytes() == (cli.TEMPLATE / f'presets/{preset}.typ').read_bytes()
        origin = json.loads((project / 'template-origin.json').read_text())
        for relative, expected in origin['upstream_files'].items():
            assert cli.digest(project / relative) == expected
        content = """# Rendering regression fixture

PRIVATE_INTRO

## S01 · Controlled comparison

### Purpose
PRIVATE_PURPOSE

### Present
```typst-math
Delta_T (t, tau) = L_0 (t, tau) - L_T (t, tau)
```

Hold observation and action target fixed. 中文思源测试。

### Context
PRIVATE_CONTEXT

### Evidence
PRIVATE_EVIDENCE

### Optional
OPTIONAL_HIDDEN

### Missing
PRIVATE_MISSING

## S02 · Evidence table

### Present
| Item | Source |
| --- | --- |
| Baseline | Original report |
| Proposed method | Pending measurement |

No measured values are asserted by this layout fixture.

## S03 · Comparison groups

### Present
#### Observations
- Fixed task.
- Shared evaluation.

---

#### Questions
- Which condition changes?
- What evidence is missing?

### Optional
OPTIONAL_VISIBLE

## S04 · Original source diagram

### Present
![Existing workspace figure, used to test layout.](assets/figure.png)
"""
        (project / 'slides.md').write_text(content, encoding='utf-8')
        shutil.copy2(cli.TEMPLATE / 'assets/la4vla.png', project / 'assets/figure.png')
        layout = {'S01': {'include_optional': False}, 'S03': {'layout': 'columns', 'columns': [3, 2]}}
        cli.write_json(project / 'layout.json', layout)
        with patch('typst.compile_with_warnings', wraps=typst.compile_with_warnings) as compiler:
            cli.build(argparse.Namespace(project=str(project), final=True, pages=None))
            assert compiler.call_count == 1
        with pymupdf.open(project / 'output/slides.pdf') as pdf:
            text = '\n'.join(page.get_text() for page in pdf)
            assert len(pdf) == 4
            assert 'PRIVATE_' not in text and 'OPTIONAL_HIDDEN' not in text
            assert 'OPTIONAL_VISIBLE' in text and 'Fixed task' in text
            fonts = {font[3] for page in pdf for font in page.get_fonts()}
            assert any('SourceHanSans' in name for name in fonts), fonts
            assert any(('Roboto' if preset == 'quarto-clean' else 'FiraSans') in name for name in fonts), fonts
        assert 'OPTIONAL_HIDDEN' in (project / 'slides.md').read_text()
        # Save final fixture output for the agent's visual inspection.
        qa = ROOT / '.cache/pipeline-tests' / name
        shutil.copytree(project, qa)
        # Local previews must be current and accurately enumerated.
        cli.build(argparse.Namespace(project=str(project), final=False, pages='3'))
        assert [path.name for path in (project / 'output/pngs').glob('*.png')] == ['slide_3.png']
        assert not (project / 'output/review.json').exists()
        assert not (project / 'output/compile-manifest.json').exists()
        # Duplicate IDs and missing selected assets must fail before publishing.
        (project / 'slides.md').write_text(content.replace('S02 ·', 'S01 ·'), encoding='utf-8')
        expect_failure(lambda: read_slides(project / 'slides.md'))
        (project / 'slides.md').write_text(content.replace('assets/figure.png', 'assets/missing.png'), encoding='utf-8')
        expect_failure(lambda: cli.build(argparse.Namespace(project=str(project), final=False, pages=None)))
        assert json.loads((project / 'output/build.json').read_text())['status'] == 'failed'
        # Reordering preserves per-ID optional selections.
        (project / 'slides.md').write_text(content, encoding='utf-8')
        from content_spec import render_content
        original, ids = render_content(project / 'slides.md', project, project / 'main.typ', 'en')
        first, remainder = content.split('## S02', 1)
        (project / 'slides.md').write_text('## S02' + remainder + '\n' + first[first.index('## S01'):], encoding='utf-8')
        reordered, reordered_ids = render_content(project / 'slides.md', project, project / 'main.typ', 'en')
        assert reordered_ids == ['S02', 'S03', 'S04', 'S01']
        assert 'OPTIONAL_HIDDEN' not in reordered
        # Exercise heading-based Markdown and native Typst entry points.
        config.pop('content_format')
        cli.write_json(project / 'deck.json', config)
        (project / 'layout.json').unlink()
        (project / 'slides.md').write_text('## Heading-based Markdown\n\n### Left\nFirst\n\n### Right\nSecond\n')
        cli.build(argparse.Namespace(project=str(project), final=False, pages=None))
        config.pop('markdown_source')
        config['expected_pages'] = 1
        cli.write_json(project / 'deck.json', config)
        (project / 'main.typ').write_text('#import "template.typ": *\n#show: research-theme.with(lang: "en")\n#discussion-slide[Native Typst entry]\n')
        cli.build(argparse.Namespace(project=str(project), final=False, pages=None))
        # Original theme-specific APIs must remain accessible beyond the common helpers.
        config['expected_pages'] = 3
        cli.write_json(project / 'deck.json', config)
        specific = ('#native.slide[#native.button[Navigation] #native.small-cite[Source attribution]]'
                    if preset == 'quarto-clean' else '#native.focus-slide[Research question]')
        (project / 'main.typ').write_text(
            '#import "template.typ": research-theme\n#import "preset.typ": native\n'
            '#show: research-theme.with(lang: "en")\n'
            '#native.title-slide(title: [Original theme], subtitle: [Native API verification])\n'
            '#native.slide[Original body page]\n' + specific, encoding='utf-8')
        cli.build(argparse.Namespace(project=str(project), final=False, pages=None))
        assert not json.loads((project / 'output/quality.json').read_text())['warnings']
        native_qa = qa.with_name(qa.name + '-native')
        shutil.copytree(project, native_qa)
        print('PASS: no-render creation, hidden context, optional selection, stable IDs, one compile, targeted previews, heading-based Markdown and Typst.')
        print(f'Visual fixture: {qa}')
        print(f'Native theme fixture: {native_qa}')
    finally:
        resolved = project.resolve()
        if resolved.parent != (ROOT / 'projects').resolve() or not resolved.name.startswith('pipeline-test-'):
            raise RuntimeError('Unexpected cleanup path')
        if resolved.exists():
            shutil.rmtree(resolved)


if __name__ == '__main__':
    for preset in cli.PRESETS:
        main(preset)

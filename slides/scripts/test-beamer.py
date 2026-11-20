"""Exercise the Beamer writer and local theme selection with the real TeX engine."""
from pathlib import Path
import shutil
import subprocess
import tempfile

import pymupdf

from beamer import THEMES, VERSIONS
from slides import ROOT, digest, write_json


def main():
    with tempfile.TemporaryDirectory(dir=ROOT / '.cache') as tmp:
        project = Path(tmp)
        fixture = ROOT / 'projects/beamer-comparison'
        for name in ('slides.md', 'layout.json', 'deck.json'):
            shutil.copyfile(fixture / name, project / name)
        shutil.copytree(fixture / 'assets', project / 'assets')
        source = project / 'slides.md'
        content = source.read_text(encoding='utf-8').replace('a^k x_0', 'a^k x_0 quad hat(x)')
        source.write_text(content.replace('比较相邻步', '`gain` 比较相邻步'), encoding='utf-8')
        write_json(project / 'layout.json', {
            'S02': {'layout': 'columns', 'include_optional': False},
            'S03': {'layout': 'columns'},
        })
        for theme, name in THEMES.items():
            subprocess.run([str(ROOT / 'slides.cmd'), 'build', str(project), '--beamer-theme', theme], check=True)
            subprocess.run([str(ROOT / 'slides.cmd'), 'check', str(project)], check=True)
            bundle = project / 'output/beamer' / theme
            sty = 'beamertheme' + name + '.sty'
            assert digest(bundle / sty) == digest(ROOT / 'template/beamer/themes' / f'{theme}-{VERSIONS[theme]}' / sty)
            assert '(./' + sty in (bundle / 'compile.log').read_text(encoding='utf-8', errors='replace')
            tex = (bundle / 'main.tex').read_text(encoding='utf-8')
            assert r'\hat{x}' in tex and 'math-' not in tex
            assert '负系数使状态逐步交替变号' not in tex and '这里仅考虑无输入' not in tex
            with pymupdf.open(bundle / 'main.pdf') as pdf:
                fonts = {font[3] for page in pdf for font in page.get_fonts()}
                for weight in ('Regular', 'Medium', 'Bold'):
                    assert any('SourceHanSans' in font and weight in font for font in fonts), fonts
                for family in ('NewCMMath', 'FiraCode'):
                    assert any(family in font for font in fonts), fonts
                assert not any(p.suffix.lower() in ('.otf', '.ttf') for p in bundle.iterdir())
                assert len(pdf) == 3
        print('PASS: local themes, native math accents, embedded fonts, shared content selection and output checks.')


if __name__ == '__main__':
    main()

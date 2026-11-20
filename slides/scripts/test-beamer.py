"""Exercise the Beamer writer and local theme selection with the real TeX engine."""
from pathlib import Path
import subprocess
import tempfile

import pymupdf

from beamer import THEMES, VERSIONS
from slides import ROOT, digest, write_json


def main():
    project = Path(tempfile.mkdtemp(prefix='beamer-font-test-', dir=ROOT / '.cache'))
    write_json(project / 'deck.json', {'markdown_source': 'slides.md', 'entry': 'main.typ', 'language': 'zh', 'content_format': 'research-slides-v2'})
    (project / 'slides.md').write_text('## S01 · English 中文标题\n\n### Present\nEnglish body 中文正文 **中文强调** `gain`\n\n| Column | 中文表头 |\n| --- | --- |\n| Data | 内容 |\n\n```latex-math\n\\hat{x} = a^k x_0\n```\n', encoding='utf-8')
    for theme, name in THEMES.items():
        subprocess.run([str(ROOT / 'slides.cmd'), 'build', str(project), '--beamer-theme', theme], check=True)
        bundle = project / 'output/beamer' / theme
        sty = 'beamertheme' + name + '.sty'
        assert digest(bundle / sty) == digest(ROOT / 'template/beamer/themes' / f'{theme}-{VERSIONS[theme]}' / sty)
        assert '(./' + sty in (bundle / 'compile.log').read_text(encoding='utf-8', errors='replace')
        tex = (bundle / 'main.tex').read_text(encoding='utf-8')
        assert r'\hat{x}' in tex and 'math-' not in tex
        with pymupdf.open(bundle / 'main.pdf') as pdf:
            fonts = {font[3] for page in pdf for font in page.get_fonts()}
            for weight in ('Regular', 'Medium', 'Bold'):
                assert any('SourceHanSans' in font and weight in font for font in fonts), fonts
            for family in ('NewCMMath', 'LMSans' if theme == 'moloch' else 'Alegreya'):
                assert any(family in font for font in fonts), fonts
            assert not any(p.suffix.lower() in ('.otf', '.ttf') for p in bundle.iterdir())
            assert len(pdf) == 1
    print('PASS: local themes, native math accents, embedded fonts, mixed Chinese/Latin text and output checks.')


if __name__ == '__main__':
    main()

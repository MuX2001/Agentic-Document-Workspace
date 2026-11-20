"""Find fonts locally and share XeTeX-compatible faces across decks."""
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
from urllib.request import urlopen

from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

HAN_URL = 'https://raw.githubusercontent.com/adobe-fonts/source-han-sans/release/SubsetOTF/CN/'
FIRA_URL = 'https://raw.githubusercontent.com/google/fonts/main/ofl/firacode/FiraCode%5Bwght%5D.ttf'


def installed_files():
    paths = []
    if os.name == 'nt':
        for folder in (Path(os.environ['LOCALAPPDATA']) / 'Microsoft/Windows/Fonts',
                       Path(os.environ['WINDIR']) / 'Fonts'):
            paths.extend(folder.glob('*'))
    if shutil.which('fc-list'):
        listing = subprocess.check_output(['fc-list', '--format=%{file}\\n'], encoding='utf-8', errors='replace')
        paths.extend(Path(line) for line in listing.splitlines())
    return {p.name.lower(): p for p in paths if p.suffix.lower() in ('.otf', '.ttf') and p.is_file()}


def fetch(cache, name, url):
    target = cache / name
    if not target.is_file():
        print(f'Downloading missing font {name} from {url}', flush=True)
        with tempfile.TemporaryDirectory(dir=cache) as tmp:
            staged = Path(tmp) / name
            with urlopen(url, timeout=90) as response, staged.open('wb') as output:
                shutil.copyfileobj(response, output)
            with TTFont(staged) as font:
                font.getBestCmap()
            os.replace(staged, target)
    return target


def face(path, weight, cache):
    with TTFont(path, lazy=True) as font:
        if 'fvar' not in font:
            return path
        stat = path.stat()
        key = hashlib.sha256(f'{path.resolve()}:{stat.st_mtime_ns}:{stat.st_size}'.encode()).hexdigest()[:12]
        target = cache / f'face-{key}-{weight}{path.suffix}'
        if not target.is_file():
            print(f'Preparing weight {weight} from {path}', flush=True)
            with tempfile.TemporaryDirectory(dir=cache) as tmp:
                staged = Path(tmp) / target.name
                instantiateVariableFont(font, {'wght': weight}, inplace=True,
                                        updateFontNames=True, static=True).save(staged)
                os.replace(staged, target)
        return target


def resolve_fonts(root):
    installed = installed_files()
    cache = root / '.cache/beamer-fonts'
    cache.mkdir(parents=True, exist_ok=True)
    faces = {}
    for style, weight in [('Regular', 400), ('Medium', 500), ('Bold', 700)]:
        name = f'SourceHanSansCN-{style}.otf'
        names = [f'SourceHanSans{region}-{style}.{ext}' for region in ('CN', 'SC') for ext in ('otf', 'ttf')]
        names += [f'SourceHanSans{region}-VF.{ext}' for region in ('CN', 'SC') for ext in ('ttf', 'otf')]
        path = next((installed[n.lower()] for n in names if n.lower() in installed), None)
        faces[style] = face(path or fetch(cache, name, HAN_URL + name), weight, cache)
    mono = next((installed[n] for n in ('firacode-regular.ttf', 'firacode-regular.otf',
                                        'firacode-variablefont_wght.ttf', 'firacode[wght].ttf') if n in installed), None)
    if mono is None:
        shared = root / 'tools/fonts/firacode/FiraCode[wght].ttf'
        mono = shared if shared.is_file() else fetch(cache, 'FiraCode-VF.ttf', FIRA_URL)
    faces['Mono'] = face(mono, 400, cache)
    return faces

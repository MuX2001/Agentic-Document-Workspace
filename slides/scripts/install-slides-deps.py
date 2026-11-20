"""Install pinned wheels from PyPI JSON metadata, without scanning large indexes."""
import hashlib
from importlib import metadata
import json
from pathlib import Path
import subprocess
import sys
import urllib.request

from pip._vendor.packaging.tags import sys_tags
from pip._vendor.packaging.utils import parse_wheel_filename


def main():
    root = Path(__file__).resolve().parents[1]
    cache = root / '.cache' / 'wheels'
    cache.mkdir(parents=True, exist_ok=True)
    tags = list(sys_tags())
    priority = {tag: index for index, tag in enumerate(tags)}
    wheels = []
    for line in (root / 'requirements-slides.txt').read_text().splitlines():
        if not line or line.startswith('#'):
            continue
        name, version = line.split('==')
        try:
            if metadata.version(name) == version:
                print(f'Installed {name}=={version}', flush=True)
                continue
        except metadata.PackageNotFoundError:
            pass
        print(f'Resolving {name}=={version}', flush=True)
        with urllib.request.urlopen(f'https://pypi.org/pypi/{name}/{version}/json', timeout=60) as response:
            data = json.load(response)
        candidates = []
        for asset in data['urls']:
            if asset['packagetype'] != 'bdist_wheel':
                continue
            supported = parse_wheel_filename(asset['filename'])[3] & priority.keys()
            if supported:
                candidates.append((min(priority[tag] for tag in supported), asset))
        if not candidates:
            raise RuntimeError(f'No wheel available for {line} and {sys.version}')
        asset = min(candidates, key=lambda item: item[0])[1]
        wheel = cache / asset['filename']
        digest = asset['digests']['sha256']
        if not wheel.exists() or hashlib.sha256(wheel.read_bytes()).hexdigest() != digest:
            print(f'Downloading {wheel.name}', flush=True)
            with urllib.request.urlopen(asset['url'], timeout=120) as response:
                payload = response.read()
            if hashlib.sha256(payload).hexdigest() != digest:
                raise RuntimeError(f'Checksum mismatch: {wheel.name}')
            wheel.write_bytes(payload)
        wheels.append(str(wheel))
    if wheels:
        subprocess.run([sys.executable, '-m', 'pip', 'install', '--no-index', '--no-deps',
                        '--disable-pip-version-check', *wheels], check=True)


if __name__ == '__main__':
    main()

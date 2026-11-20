"""Cache the fixed Touying package via Python TLS for Windows environments."""
import hashlib
import io
import json
from pathlib import Path
import tarfile
import urllib.request

ROOT = Path(__file__).resolve().parents[1]


def fetch(name, version):
    cache = ROOT / '.cache' / 'typst-packages'
    destination = cache / 'preview' / name / version
    receipt = cache / 'downloads.json'
    if (destination / 'typst.toml').exists():
        print(f'Cached {name}:{version}')
        return
    url = f'https://packages.typst.org/preview/{name}-{version}.tar.gz'
    print(f'Downloading {name}:{version}', flush=True)
    with urllib.request.urlopen(url, timeout=120) as response:
        payload = response.read()
    destination.mkdir(parents=True, exist_ok=True)
    with tarfile.open(fileobj=io.BytesIO(payload), mode='r:gz') as archive:
        for member in archive.getmembers():
            target = (destination / member.name).resolve()
            if not target.is_relative_to(destination.resolve()) or member.issym() or member.islnk():
                raise ValueError(f'Unsafe package member: {member.name}')
        archive.extractall(destination, filter='data')
    records = json.loads(receipt.read_text()) if receipt.exists() else {}
    records[f'{name}:{version}'] = {
        'url': url, 'archive_sha256': hashlib.sha256(payload).hexdigest(),
    }
    receipt.write_text(json.dumps(records, indent=2) + '\n', encoding='utf-8')
    print(destination)


if __name__ == '__main__':
    fetch('touying', '0.7.4')
    fetch('uniwarn', '0.1.1')
    fetch('touying-quarto-clean', '0.2.1')
    fetch('touying-quarto-clean', '0.2.1')

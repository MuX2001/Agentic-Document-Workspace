import { existsSync } from 'node:fs';
import { mkdtemp, rename, rm, stat } from 'node:fs/promises';
import { execFileSync } from 'node:child_process';
import { dirname, extname, join, resolve } from 'node:path';

const input = resolve(process.argv[2] || '');
const extension = extname(input).toLowerCase();
if (extension === '.excalidraw') {
  await import('./renderer/export-excalidraw.mjs');
} else if (extension === '.drawio') {
  const executable = process.env.DRAWIO_BIN || [
    process.env.ProgramFiles && join(process.env.ProgramFiles, 'draw.io/draw.io.exe'),
    process.env.LOCALAPPDATA && join(process.env.LOCALAPPDATA, 'Programs/draw.io/draw.io.exe'),
    'D:/bin/editor/draw.io/draw.io.exe',
    '/Applications/draw.io.app/Contents/MacOS/draw.io'
  ].find(path => path && existsSync(path)) || 'drawio';
  const environment = {...process.env};
  delete environment.ELECTRON_RUN_AS_NODE;
  const staging = await mkdtemp(join(dirname(input), '.drawio-export-'));
  try {
    for (const format of ['svg', 'png']) {
      const output = join(staging, 'preview.' + format);
      execFileSync(executable, ['--export', '--format', format, '--border', '12',
        '--output', output, input], {stdio:'inherit', windowsHide:true, env:environment});
      if (!(await stat(output)).size) throw new Error('Empty export: ' + output);
    }
    for (const format of ['svg', 'png']) {
      await rename(join(staging, 'preview.' + format), input.slice(0, -extension.length) + '.' + format);
    }
  } finally {
    await rm(staging, {recursive:true, force:true});
  }
} else {
  throw new Error('Usage: node export.mjs <file.drawio | file.excalidraw>');
}

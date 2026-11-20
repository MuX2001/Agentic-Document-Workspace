import { existsSync } from 'node:fs';
import { readFile, writeFile } from 'node:fs/promises';
import { resolve, extname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createServer } from 'vite';
import { chromium } from 'playwright';

const input = process.argv[2];
if (extname(input || '').toLowerCase() !== '.excalidraw') {
  throw new Error('Usage: node export.mjs <file.excalidraw>');
}
const filename = resolve(input);
const scene = JSON.parse((await readFile(filename, 'utf8')).replace(/^\uFEFF/, ''));
if (scene.type !== 'excalidraw' || !scene.elements?.some(el => !el.isDeleted)) {
  throw new Error('Expected an Excalidraw scene with visible elements');
}
const root = fileURLToPath(new URL('./', import.meta.url));
const server = await createServer({root, logLevel:'error', server:{host:'127.0.0.1', port:0}, optimizeDeps:{include:['@excalidraw/excalidraw']}});
let browser;
try {
  await server.listen();
  const executablePath = process.platform === 'win32' ? [
    process.env.ProgramFiles + '/Google/Chrome/Application/chrome.exe',
    process.env['ProgramFiles(x86)'] + '/Microsoft/Edge/Application/msedge.exe'
  ].find(existsSync) : undefined;
  browser = await chromium.launch({executablePath});
  const page = await browser.newPage({deviceScaleFactor:2});
  page.on('pageerror', error => console.error(error.message));
  await page.goto(server.resolvedUrls.local[0]);
  await page.waitForFunction(() => typeof window.renderScene === 'function', null, {timeout:60000});
  const svg = await page.evaluate(scene => window.renderScene(scene), scene);
  const stem = filename.slice(0, -extname(filename).length);
  await page.locator('#drawing > svg').screenshot({path:stem + '.png', timeout:60000});
  await writeFile(stem + '.svg', svg);
} finally {
  await browser?.close();
  await server.close();
}

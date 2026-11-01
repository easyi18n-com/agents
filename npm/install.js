#!/usr/bin/env node
// Downloads the easyi18n binary for this platform from the CLI Release whose
// version is this package's, verifies it against that Release's SHA256SUMS and
// checks it runs before it lands in vendor/. Every message goes to stderr: the
// bin shim calls this too, and under `npx … mcp` stdout is the MCP channel.
'use strict';
const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const { version } = require('./package.json');

const ASSETS = {
  'darwin arm64': 'easyi18n-macos-arm64',
  'darwin x64': 'easyi18n-macos-x64',
  'linux x64': 'easyi18n-linux-x64',
  'win32 x64': 'easyi18n-windows-x64.exe',
};

function assetFor(platform, arch) {
  const asset = ASSETS[`${platform} ${arch}`];
  if (!asset) {
    throw new Error(`no prebuilt binary for ${platform} ${arch}; install with \`dart pub global activate easyi18n_cli\``);
  }
  return asset;
}

function binaryPath() {
  return path.join(__dirname, 'vendor', process.platform === 'win32' ? 'easyi18n.exe' : 'easyi18n');
}

async function download(url) {
  const res = await fetch(url).catch((e) => {
    throw new Error(`download failed: ${url} (${e.cause?.code ?? e.message})`);
  });
  if (!res.ok) throw new Error(`download failed: ${url} (HTTP ${res.status})`);
  return Buffer.from(await res.arrayBuffer());
}

async function install() {
  const asset = assetFor(process.platform, process.arch);
  const releases = process.env.EASYI18N_RELEASES_URL || 'https://github.com/liontude/easyi18n-dart/releases';
  const base = `${releases}/download/cli-v${version}`;
  const binary = await download(`${base}/${asset}`);
  const sums = (await download(`${base}/SHA256SUMS`)).toString('utf8');
  const expected = sums
    .split('\n')
    .map((line) => line.trim().split(/\s+/))
    .find(([, name]) => name === asset)?.[0];
  if (!expected) throw new Error(`no checksum for ${asset} in SHA256SUMS`);
  const actual = crypto.createHash('sha256').update(binary).digest('hex');
  if (actual !== expected) throw new Error(`checksum mismatch for ${asset}: expected ${expected}, got ${actual}`);

  const dest = binaryPath();
  // Same extension as the destination: Windows decides what runs by it.
  const tmp = path.join(path.dirname(dest), `.${process.pid}-${path.basename(dest)}`);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  try {
    fs.writeFileSync(tmp, binary, { mode: 0o755 });
    if (spawnSync(tmp, ['--version'], { stdio: 'ignore' }).status !== 0) {
      throw new Error(`the downloaded ${asset} does not run on this machine`);
    }
    fs.renameSync(tmp, dest);
  } finally {
    fs.rmSync(tmp, { force: true });
  }
  process.stderr.write(`easyi18n: installed ${asset} ${version}\n`);
  return dest;
}

module.exports = { assetFor, binaryPath, install };

if (require.main === module) {
  // A failed postinstall makes npx abort before the shim runs, and npx prints
  // none of the script's output. Succeeding leaves vendor/ empty, so the shim
  // installs again on its first run and says why on stderr.
  install().catch((e) => {
    process.stderr.write(`easyi18n install: ${e.message}\n`);
  });
}

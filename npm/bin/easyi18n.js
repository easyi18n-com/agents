#!/usr/bin/env node
// Runs the binary install.js put in vendor/, with this process's stdio, so
// `npx -y @easyi18n.com/cli mcp` speaks MCP straight from the binary.
'use strict';
const fs = require('node:fs');
const { spawn } = require('node:child_process');
const { binaryPath, install } = require('../install.js');

async function main() {
  let bin = binaryPath();
  // postinstall does not run under --ignore-scripts, nor by default in pnpm 10.
  if (!fs.existsSync(bin)) bin = await install();
  const child = spawn(bin, process.argv.slice(2), { stdio: 'inherit' });
  const signals = ['SIGINT', 'SIGTERM', 'SIGHUP'];
  for (const signal of signals) process.on(signal, () => child.kill(signal));
  child.on('error', (e) => {
    process.stderr.write(`easyi18n: ${e.message}\n`);
    process.exit(1);
  });
  child.on('exit', (code, signal) => {
    if (signal) {
      for (const s of signals) process.removeAllListeners(s);
      process.kill(process.pid, signal);
    } else {
      process.exit(code);
    }
  });
}

main().catch((e) => {
  process.stderr.write(`easyi18n: ${e.message}\n`);
  process.exit(1);
});

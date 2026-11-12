# @easyi18n.com/cli

The [easyi18n](https://easyi18n.com) CLI as a prebuilt binary, so it runs
without the Dart SDK. The install downloads the binary for your platform from
the matching `cli-v<version>` release of
[easyi18n-com/dart](https://github.com/easyi18n-com/dart/releases)
and refuses it unless its sha256 matches that release's `SHA256SUMS`.

Binaries exist for macOS (arm64, x64), Linux x64 and Windows x64. On any other
platform, or if you already have Dart, use
`dart pub global activate easyi18n_cli`.

## MCP server

```sh
claude mcp add --transport stdio easyi18n -- npx -y @easyi18n.com/cli@1.3.0 mcp
```

Any MCP client that launches a stdio server takes the same command:
`npx -y @easyi18n.com/cli@1.3.0 mcp`. The server sends the login that
`easyi18n login` stores on the machine, so run that once and approve the code
in your browser. For CI, or an agent whose spending waits for approval, pass
`--require-agent-key` and an agent key from the dashboard in `EASYI18N_TOKEN`;
`easyi18n mcp config --client <client> --agent-key` prints that form.

## CLI

```sh
npm install -g @easyi18n.com/cli
easyi18n --help
```

With `--ignore-scripts`, or under pnpm's default of not running dependency
scripts, the binary is downloaded on the first run instead. The same happens
when the install cannot get the binary: the install still succeeds, and the
first run tries again and prints the reason on stderr.

`EASYI18N_RELEASES_URL` points the download at another copy of the releases
page, such as an internal mirror.

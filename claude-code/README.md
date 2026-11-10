# easyi18n

The [easyi18n](https://easyi18n.com) plugin lets Claude set up translations in
a Flutter, Xcode, Angular, web or Android project, translate the strings and
publish them. With your `easyi18n login`, Claude spends credits, publishes and
rolls back as you. With an agent key, each of those waits until a person
approves it in the easyi18n dashboard.

The plugin contains the easyi18n MCP server, two skills and one command. You
need an easyi18n account and, to translate, your login or an agent key from
your project.

## What you can ask

- "Add easyi18n to this project." The `setup` skill detects the
  stack, writes the configuration, checks it with `doctor` and shows what
  would be translated. It spends nothing and runs without a login or a key.
- "Translate the app into Spanish and German, then publish." The
  `translate` skill shows the credit estimate, waits for the
  translation, publishes and writes the translated files into the repository.
  With an agent key it gives you an approval link for the spend and asks for a
  second approval to publish.
- "Roll back the last publish." Claude restores the previous published version
  as a new one, after an approval when it uses an agent key.
- `/easyi18n:doctor` runs the `doctor` checks and fixes the failing
  ones until none fail.

## Supported projects

| Project | Where the strings live |
| --- | --- |
| Flutter with `context.tr()` | The `tr()` calls in your code |
| Xcode | String Catalogs (`.xcstrings`) |
| Angular with `@angular/localize` | The JSON file `ng extract-i18n` writes |
| Web apps with Transloco, ngx-translate or i18next | One JSON file per locale |
| Android | `res/values/strings.xml` |

Flutter ARB files, other JSON layouts, iOS `.strings` and gettext `.po` files
can download published translations, but their strings are imported through
the dashboard first.

## Install and log in

Add this repository's marketplace and install the plugin:

```text
/plugin marketplace add liontude/easyi18n-agents
/plugin install easyi18n
```

Then run `easyi18n login` in a terminal and approve the code it shows in your
browser. The plugin's next call uses that login, for 30 days.

For an agent that must not spend or publish without your approval, give the
plugin an agent key instead:

1. In the easyi18n dashboard, open your project, then **Settings**, **API
   keys**, **New API key**. Choose the scopes and set **Used by** to **AI
   agent**.
2. In Claude Code, open `/plugin`, select easyi18n, choose **Configure** and
   paste the key. Claude Code stores it as a sensitive setting. Do not paste it
   into the chat: the server never accepts the key as a tool argument.
3. Run `/mcp` to check that the easyi18n server is connected.

The easyi18n API enforces those limits on the key itself: an agent key cannot
spend credits, publish or roll back without an operation that a person
approved, whichever client uses it.

## Installed before the rename

Until November 2026 the marketplace was named `easyi18n`, and the command,
the skills and the server carried the plugin's name twice. An install made
then keeps those names until the plugin's next version, and keeps the old
marketplace name after that. Adding the marketplace again changes nothing
while the old one is registered. To move to the current names, remove the old
install first:

```text
/plugin uninstall easyi18n@easyi18n
/plugin marketplace remove easyi18n
/plugin marketplace add liontude/easyi18n-agents
/plugin install easyi18n
```

Then open `/plugin`, select easyi18n and **Configure** if you use an agent
key. The server's tools are now named `mcp__plugin_easyi18n_cli__<tool>`. A
permission rule written with `mcp__plugin_easyi18n_easyi18n__` no longer
matches: rewrite it with the new prefix.

## What the plugin runs, downloads and sends

**Runs.** When Claude Code starts the plugin's MCP server, `bin/easyi18n-mcp`
runs `scripts/ensure-cli.sh`, which finds or downloads the CLI and starts
`easyi18n mcp`. The plugin has no hooks.

**Downloads.** The plugin uses the easyi18n CLI version written in
`cli-version`. If an `easyi18n` on your `PATH`, or `dart pub global run
easyi18n_cli:easyi18n`, reports exactly that version, the plugin uses it and
downloads nothing. Otherwise it downloads that version's `install.sh` and
binary from the
[liontude/easyi18n-dart releases](https://github.com/liontude/easyi18n-dart/releases),
checks the binary against the release's `SHA256SUMS`, and keeps it in the
plugin's data folder. `EASYI18N_RELEASES_URL` can override the download source.
It deletes cached copies of other versions. The CLI's
source is in
[liontude/easyi18n-dart](https://github.com/liontude/easyi18n-dart/tree/main/packages/easyi18n_cli)
and on [pub.dev](https://pub.dev/packages/easyi18n_cli).

**Sends.** The MCP server sends requests to `https://api.easyi18n.com` with
your login or your agent key: the keys, source text and translations of the strings it
manages, and the languages and versions you ask for. If the repository's
`easyi18n.yaml` points at a host other than `api.easyi18n.com` or your own
machine, the server refuses to send a credential there unless you explicitly trust
that exact origin through `EASYI18N_BASE_URL` in the MCP server's environment.
A login only goes back to the origin that approved it.
The CLI sends no telemetry.

**Writes.** In your repository, `init` writes `easyi18n.yaml` and wires the
easyi18n SDK or the project's translation files; translating keeps its state
in `easyi18n.lock` and `.easyi18n/`; `pull` writes the translated files; in a
Flutter project, `apply` rewrites the `tr()` strings that a reviewer corrected
in the dashboard. Each write is a tool call that Claude Code shows you.

## Troubleshooting

- `/mcp` shows easyi18n as failed: the first session downloads the CLI from
  GitHub. Without access to `github.com`, the server logs
  `easyi18n plugin: download failed` with the URL. Install the CLI version in
  `cli-version` yourself, from pub.dev or the release, and start a new session.
- `doctor` reports a `credential` warning: there is no login and no agent
  key. Run `easyi18n login`, or add a key under `/plugin`, easyi18n,
  **Configure**.
- An approval link stopped working: a pending approval expires after 30
  minutes. Ask Claude to try again.

## Privacy, terms and support

- [Privacy policy](https://easyi18n.com/privacy/) and
  [terms](https://easyi18n.com/terms/)
- [Documentation](https://docs.easyi18n.com/developers/agents/claude-code-plugin)
- Support: info@easyi18n.com, or an issue at
  [liontude/easyi18n-agents](https://github.com/liontude/easyi18n-agents/issues)

The plugin is MIT licensed.

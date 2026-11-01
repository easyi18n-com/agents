# easyi18n for AI agents

The [easyi18n](https://easyi18n.com) MCP server and the integrations that
install it. An agent connected to it can set up easyi18n in a Flutter, Xcode,
web or Android project, translate the strings and publish them. Every spend,
publish and rollback it asks for waits until a human approves it in the
easyi18n dashboard.

| Directory | What it is |
|---|---|
| `claude-code/` | The Claude Code plugin: MCP server, `setup` and `translate` skills, `/easyi18n-doctor` |
| `clients/` | The MCP config snippet for every other client (Cursor, VS Code, Codex, Gemini CLI, and more) |
| `npm/` | `@easyi18n.com/cli`, the CLI as a prebuilt binary, for clients that launch the server with `npx` |

## Claude Code

```
/plugin marketplace add liontude/easyi18n-agents
/plugin install easyi18n@easyi18n
```

The first session after the install downloads the CLI the plugin is pinned
to, verified against its release's `SHA256SUMS`. An `easyi18n` or
`dart pub global run easyi18n_cli:easyi18n` of that same version is used
instead when one is installed.

The plugin reads your agent key from its configuration: `/plugin`, then
easyi18n, then Configure. Create the key in the dashboard under Project >
Settings > API keys > New API key, with Used by set to AI agent. The `setup`
skill runs before the key exists and tells you when to add it. Check the connection with `/mcp`.

A team that works across several easyi18n projects can give each repository
its own key in place of the plugin: a `.mcp.json` at the project root that
takes the key from the environment Claude Code was started in.

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "npx",
      "args": ["-y", "@easyi18n.com/cli@1.0.0", "mcp"],
      "env": { "EASYI18N_TOKEN": "${EASYI18N_TOKEN}" }
    }
  }
}
```

## Other clients

[`clients/README.md`](clients/README.md) has the snippet for each client,
the same text `easyi18n mcp config --client <client>` prints.

## Source

This repository is a one-way mirror of `integrations/agents/` in the easyi18n
monorepo. The skills are generated from the MCP server's prompts and the
client snippets from the CLI, so a change made here is overwritten by the
next sync. Report issues at https://github.com/liontude/easyi18n-agents/issues.

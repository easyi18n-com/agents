# Connect an MCP client

Generated from `easyi18n mcp config --client <client>` by
`packages/easyi18n_cli/tool/gen_agent_integrations.dart`. Edit
`packages/easyi18n_cli/lib/src/mcp/client_config.dart` and
regenerate: CI fails on a hand edit.

The first snippet of each client runs the npm package
`@easyi18n.com/cli`, which needs Node and no Dart SDK. The second
runs the Dart package after `dart pub global activate easyi18n_cli`.
`eik_YOUR_AGENT_KEY` stands for an AI agent key, created in the
dashboard: every spend, publish and rollback it makes waits for a
human approval.

## Claude Code (`claude-code`)

Run it in a terminal in the project. It registers the server in local scope, which stays out of the repo.

```sh
claude mcp add --env EASYI18N_TOKEN=eik_YOUR_AGENT_KEY --transport stdio easyi18n -- npx -y @easyi18n.com/cli@1.0.0 mcp
```

With the Dart SDK:

```sh
claude mcp add --env EASYI18N_TOKEN=eik_YOUR_AGENT_KEY --transport stdio easyi18n -- dart pub global run easyi18n_cli:easyi18n mcp
```

## Claude Desktop (`claude-desktop`)

Merge it into claude_desktop_config.json (Settings, Developer, Edit Config) and restart Claude. Claude Desktop has no project, so the agent names one with project_dir.

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

## Cursor (`cursor`)

Merge it into .cursor/mcp.json in the project. Cursor reads EASYI18N_TOKEN from the environment it was started in.

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "${env:EASYI18N_TOKEN}",
        "EASYI18N_PROJECT_DIR": "${workspaceFolder}"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "${env:EASYI18N_TOKEN}",
        "EASYI18N_PROJECT_DIR": "${workspaceFolder}"
      }
    }
  }
}
```

## VS Code (`vscode`)

Merge it into .vscode/mcp.json in the project. VS Code asks for the key once and stores it.

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "easyi18n-token",
      "description": "easyi18n AI agent key (eik_)",
      "password": true
    }
  ],
  "servers": {
    "easyi18n": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "${input:easyi18n-token}",
        "EASYI18N_PROJECT_DIR": "${workspaceFolder}"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "easyi18n-token",
      "description": "easyi18n AI agent key (eik_)",
      "password": true
    }
  ],
  "servers": {
    "easyi18n": {
      "type": "stdio",
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "${input:easyi18n-token}",
        "EASYI18N_PROJECT_DIR": "${workspaceFolder}"
      }
    }
  }
}
```

## Codex CLI (`codex`)

Append it to ~/.codex/config.toml. Codex forwards EASYI18N_TOKEN from the shell it runs in.

```toml
[mcp_servers.easyi18n]
command = "npx"
args = ["-y", "@easyi18n.com/cli@1.0.0", "mcp"]
env_vars = ["EASYI18N_TOKEN"]
startup_timeout_sec = 60
required = true
omit_tools_from = ["deferred"]
```

With the Dart SDK:

```toml
[mcp_servers.easyi18n]
command = "dart"
args = ["pub", "global", "run", "easyi18n_cli:easyi18n", "mcp"]
env_vars = ["EASYI18N_TOKEN"]
startup_timeout_sec = 60
required = true
omit_tools_from = ["deferred"]
```

## Gemini CLI (`gemini`)

Merge it into .gemini/settings.json in the project. Gemini CLI reads EASYI18N_TOKEN from the shell it runs in.

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "$EASYI18N_TOKEN"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "$EASYI18N_TOKEN"
      }
    }
  }
}
```

## Windsurf (`windsurf`)

Merge it into Windsurf's mcp_config.json.

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

## Zed (`zed`)

Merge it into Zed's user settings.json.

```json
{
  "context_servers": {
    "easyi18n": {
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "context_servers": {
    "easyi18n": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

## Any other MCP client (`generic`)

Merge it into the client's MCP config: most read this mcpServers shape.

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "npx",
      "args": [
        "-y",
        "@easyi18n.com/cli@1.0.0",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

With the Dart SDK:

```json
{
  "mcpServers": {
    "easyi18n": {
      "command": "dart",
      "args": [
        "pub",
        "global",
        "run",
        "easyi18n_cli:easyi18n",
        "mcp"
      ],
      "env": {
        "EASYI18N_TOKEN": "eik_YOUR_AGENT_KEY"
      }
    }
  }
}
```

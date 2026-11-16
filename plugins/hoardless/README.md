# Hoardless

Disk context for coding agents on a Mac. Ask your agent what is filling the disk and get an answer from your [Hoardless](https://hoardless.app) scan: used and free space, the biggest developer caches, and what Claude Code, Codex, Cursor and local models left behind.

**This plugin needs the Hoardless app.** Hoardless is a paid macOS app (macOS 14 or later) with a 14-day trial. The plugin holds no scanner and no server of its own. Without the app it does nothing and says so.

**It is read-only.** Nothing in this plugin, and no tool of the Hoardless MCP server, can move, trash or delete a file. An agent can build a cleanup plan and open it in the app. Only you can run it, by pressing the button in Hoardless.

## What you get

| Part | What it does |
|---|---|
| `/hoardless:disk` | A skill that answers "where did my disk space go" in at most 3 bullets |
| MCP server `hoardless` | Storage overview, apps, developer caches, unused items, growth over time, and a reclaim preview |
| SessionStart hook | One line of context when free space is under your limit or agent leftovers pass 5 GB. Silent otherwise |

## Setup

1. Install Hoardless from [hoardless.app](https://hoardless.app), open it once and run a scan.
2. Install this plugin in Claude Code:

   ```
   /plugin install hoardless --marketplace AIiteo/hoardless-agent-plugin
   ```

3. Ask "what is filling my disk?" or run `/hoardless:disk`.

## What it runs and reads

Everything stays on your Mac. The plugin makes no network request and sends no data anywhere.

- `scripts/hoardless-mcp.sh` starts the MCP server. It runs `~/.hoardless/bin/hoardless-mcp`, a link the app keeps pointed at the server inside `Hoardless.app`. If the link is missing it prints one line asking you to install the app, then exits.
- `scripts/session-start.sh` reads `~/.hoardless/run/status.json`, a small file the app writes that holds sizes and dates only, never file names or paths. It runs `plutil` and `awk`, prints at most one line, and writes nothing.
- The MCP server reads the scan index at `~/.hoardless/index.sqlite`, or talks to the running app over a local socket. It can start a scan when you ask. It cannot delete.

After the trial, the storage overview, scan status and scan list stay free. The other tools ask for a license.

## Codex

The same folder is a Codex plugin. Install it from the Hoardless app (AI and agents, then Install), which sets the server path Codex needs.

## Links

- App and download: [hoardless.app](https://hoardless.app)
- MCP tools and setup for other clients: [hoardless.app/mcp](https://hoardless.app/mcp)
- Privacy: [hoardless.app/privacy](https://hoardless.app/privacy)
- Support: support@hoardless.app

## License

MIT, for the files in this plugin. The Hoardless app is separate, closed-source software under its own terms.

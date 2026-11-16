# Hoardless agent plugin

Disk context for coding agents on a Mac. Ask Claude Code, Codex, Cursor or any MCP client what is filling the disk and get an answer from your [Hoardless](https://hoardless.app) scan.

| | |
|---|---|
| Needs | The Hoardless app for macOS 14 or later (paid, 14-day trial), opened once |
| Can do | Read your scan, start a scan when you ask, build a cleanup preview, open that preview in the app |
| Cannot do | Move, trash or delete anything. Only you run a cleanup, in the app |
| Sends | Nothing. No network requests, everything stays on your Mac |

This repository holds the plugin files only: a skill, a hook, and a small script that starts the MCP server inside the Hoardless app. The app and the server are closed source and are not here.

## Install

### Claude Code

```
/plugin marketplace add AIiteo/hoardless-agent-plugin
/plugin install hoardless@hoardless
```

Then ask "what is filling my disk?" or run `/hoardless:disk`.

### Codex

Install from the Hoardless app: AI and agents, then Install next to Codex. The app sets the server path Codex needs.

### Cursor and other MCP clients

Point the client at the server inside the app:

```json
{
  "mcpServers": {
    "hoardless": {
      "command": "/Applications/Hoardless.app/Contents/MacOS/hoardless-mcp"
    }
  }
}
```

More clients and the full tool reference: [hoardless.app/mcp](https://hoardless.app/mcp).

## Tools

All tools are read-only except `start_scan`, which starts a scan in the app and asks for `confirm: true`.

| Tool | Answers |
|---|---|
| `get_storage_overview` | Used and free space, by category |
| `list_apps`, `get_app_details` | What each app holds, with its leftovers |
| `list_dev_caches` | Developer caches, agent leftovers and local models |
| `list_unused` | Items not used in a long time |
| `get_category_details`, `investigate_folder` | Why one category or folder is big |
| `growth_timeline`, `explain_growth`, `get_date_range_breakdown` | What grew, and when |
| `disk_watch_status` | Free space trend and forecast |
| `preview_reclaim`, `open_reclaim_in_app` | A cleanup plan to review in the app. Never runs it |
| `get_reclaim_history` | What you reclaimed before |
| `list_scans`, `get_scan_status`, `start_scan` | Scans |

After the trial, `get_storage_overview`, `get_scan_status`, `list_scans` and `start_scan` stay free. The rest ask for a license.

## What is in this repository

| Path | What |
|---|---|
| `plugins/hoardless/` | The plugin: manifest, skill, hook, launcher script, README, license |
| `.claude-plugin/marketplace.json` | Lets Claude Code install the plugin from this repository |
| `server.json` | Entry for the official MCP Registry |
| `mcpb/manifest.json`, `scripts/pack-mcpb.sh` | Builds the `.mcpb` bundle attached to each release |

What each script runs and reads is listed in [plugins/hoardless/README.md](plugins/hoardless/README.md).

## Support

- Site: [hoardless.app](https://hoardless.app)
- Email: support@hoardless.app
- Privacy: [hoardless.app/privacy](https://hoardless.app/privacy)

## License

MIT for the files in this repository. The Hoardless app is separate software under its own terms.

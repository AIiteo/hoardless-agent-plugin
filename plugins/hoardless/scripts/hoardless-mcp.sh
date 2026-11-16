#!/bin/sh
# Starts the Hoardless MCP server (stdio). Read-only: the server has no tool
# that moves, trashes or deletes anything.
#
# The server is not in this plugin. It ships inside the Hoardless app, which
# keeps ~/.hoardless/bin/hoardless-mcp pointing at it. This script only hands
# over to that file. It downloads nothing and writes nothing.

if [ -x ~/.hoardless/bin/hoardless-mcp ]; then
    exec ~/.hoardless/bin/hoardless-mcp
fi

echo "Hoardless: the Hoardless app is not set up on this Mac." >&2
echo "Install it from https://hoardless.app and open it once, then restart this session." >&2
exit 1

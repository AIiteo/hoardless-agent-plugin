#!/bin/sh
# Builds dist/hoardless.mcpb for a GitHub release and writes its SHA-256 into
# server.json. The bundle holds the manifest, the launcher script, the icon
# and the license. It holds no server: the launcher starts the one inside the
# Hoardless app.
#
# Usage: scripts/pack-mcpb.sh   (run from the repository root)

set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/server" "$root/dist"
cp "$root/mcpb/manifest.json" "$work/manifest.json"
cp "$root/plugins/hoardless/scripts/hoardless-mcp.sh" "$work/server/hoardless-mcp.sh"
cp "$root/plugins/hoardless/.claude-plugin/icon.png" "$work/icon.png"
cp "$root/LICENSE" "$work/LICENSE"
chmod 755 "$work/server/hoardless-mcp.sh"
# Fixed dates and order, so the same files always give the same hash.
find "$work" -exec touch -t 202601010000 {} +

out="$root/dist/hoardless.mcpb"
rm -f "$out"
(cd "$work" && zip -X -q "$out" manifest.json icon.png LICENSE server/hoardless-mcp.sh)

sum=$(shasum -a 256 "$out" | cut -d ' ' -f 1)
sed -i.bak "s/\"fileSha256\": \"[0-9a-f]*\"/\"fileSha256\": \"$sum\"/" "$root/server.json"
rm -f "$root/server.json.bak"

echo "$out"
echo "sha256 $sum (written to server.json)"

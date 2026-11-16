#!/bin/sh
# Hoardless SessionStart hook (Claude Code and Codex). Read-only.
#
# Reads ~/.hoardless/run/status.json, which the Hoardless app writes after
# each scan, reclaim and disk watch sample. Prints nothing unless free space
# is below the user's Hoardless free floor, or agent leftovers from the last
# scan are large. Then it prints one short line of context. A missing, stale
# or unreadable file prints nothing. Always exits 0.
#
# Test seams: HOARDLESS_STATUS_FILE (path), HOARDLESS_NOW (epoch seconds).

f=${HOARDLESS_STATUS_FILE:-$HOME/.hoardless/run/status.json}
[ -r "$f" ] || exit 0
now=${HOARDLESS_NOW:-$(/bin/date +%s)}

/usr/bin/plutil -p "$f" 2>/dev/null | /usr/bin/awk -v now="$now" '
BEGIN {
    # Only these names are counted or printed: the display names in
    # AgentStatusFile.agentTools (AgentPluginHookTests keeps them in sync).
    tool["Claude Code"] = 1
    tool["Codex"] = 1
    tool["Cursor"] = 1
    tool["Gemini CLI"] = 1
}
function gb(b,  v) {
    v = b / 1e9
    return (v >= 100) ? sprintf("%.0f GB", v) : sprintf("%.1f GB", v)
}
/=> \{$/ { split($0, q, "\""); sect = q[2]; next }
/^ *\}/ { sect = ""; next }
/=>/ {
    split($0, q, "\"")
    key = q[2]
    val = $0
    sub(/.*=> */, "", val)
    gsub(/"/, "", val)
    if (sect == "agentLeftovers") {
        if (key in tool) { n++; name[n] = key; size[n] = val + 0; total += val + 0 }
    }
    else if (sect == "") top[key] = val
}
END {
    if (top["version"] != 1) exit
    written = top["writtenAt"] + 0
    age = now - written
    if (written <= 0 || age < 0 || age > 14 * 86400) exit

    msg = ""
    floor = top["freeFloorBytes"] + 0
    if (("freeBytes" in top) && floor > 0 && age <= 6 * 3600 && (top["freeBytes"] + 0) < floor) {
        msg = gb(top["freeBytes"] + 0) " free, below the " gb(floor) " floor set in Hoardless."
    }

    scan = top["scanAt"] + 0
    if (total >= 5e9 && scan > 0 && now - scan >= 0 && now - scan <= 30 * 86400) {
        for (i = 1; i <= n; i++) idx[i] = i
        for (i = 1; i <= n; i++)
            for (j = i + 1; j <= n; j++)
                if (size[idx[j]] > size[idx[i]]) { t = idx[i]; idx[i] = idx[j]; idx[j] = t }
        list = ""
        for (i = 1; i <= n && i <= 3; i++) {
            if (size[idx[i]] < 5e7) continue
            list = list (list == "" ? "" : ", ") name[idx[i]] " " gb(size[idx[i]])
        }
        if (list != "") msg = msg (msg == "" ? "" : " ") "Agent leftovers in the last scan: " list "."
    }

    if (msg != "") print "Hoardless: " msg " The /hoardless:disk command shows a read-only breakdown."
}'
exit 0

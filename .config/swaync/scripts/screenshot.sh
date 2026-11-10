#!/usr/bin/env bash
# Region screenshot: select an area, save it, copy to clipboard, notify.
set -euo pipefail

GRIM="$(command -v grim || echo "$HOME/.local/bin/grim")"
SLURP="$(command -v slurp || echo "$HOME/.local/bin/slurp")"

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
out="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

if geom="$("$SLURP")" && [ -n "$geom" ]; then
    "$GRIM" -g "$geom" "$out"
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy <"$out"
    fi
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -i "$out" "Screenshot saved" "$out"
    fi
fi

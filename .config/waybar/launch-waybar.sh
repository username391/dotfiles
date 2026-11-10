#!/usr/bin/env bash
# Restart waybar when its config files change.
#
#   ./launch-waybar.sh          toggle waybar (stop if running)
#   ./launch-waybar.sh --start  start and follow config changes

set -u

BAR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
WATCH_DIR="$BAR_DIR"

start_waybar() {
	waybar -c "$BAR_DIR/config" -s "$BAR_DIR/style.css" &
}

start_swaync() {
	if command -v swaync >/dev/null 2>&1 && ! pgrep -x swaync >/dev/null; then
		swaync &
	fi
}

# Toggle behaviour used by the SUPER+W keybind.
if [[ "${1:-}" != "--start" ]] && pgrep -x waybar >/dev/null; then
	pkill -x waybar
	pkill -f "launch-waybar.sh"
	exit 0
fi

trap 'pkill -x waybar' EXIT

while true; do
	start_waybar
	start_swaync

	# Any change in the waybar directory triggers a restart.
	inotifywait -qq -e close_write,create,delete,move "$WATCH_DIR" || sleep 1

	pkill -x waybar
	sleep 0.2
done

#!/bin/bash

CONFIG_FILES=("$HOME/.config/waybar/config" "$HOME/.config/waybar/style.css" "$HOME/.config/waybar/modules.jsonc")

# Проверяем, запущен ли waybar
if pgrep -x waybar >/dev/null; then
	killall waybar
	exit 0
fi

trap "killall waybar" EXIT

while true; do
	killall waybar
	waybar &
	inotifywait -e create,modify "${CONFIG_FILES[@]}"
done

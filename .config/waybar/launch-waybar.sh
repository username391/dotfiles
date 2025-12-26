#!/bin/bash

CONFIG_FILES=("$HOME/.config/waybar/config" "$HOME/.config/waybar/style.css" "$HOME/.config/waybar/modules.jsonc")

# Проверяем, запущен ли waybar
if pgrep -x waybar >/dev/null; then
	killall waybar
	# FIXME: возможно стоит получать
	# название текущего файла динамически
	pkill -f "launch-waybar.sh"
	exit 0
fi

trap "killall waybar" EXIT

while true; do
	killall -9 waybar &
	killall -9 swaync &
	sleep 0.5
	waybar &
	swaync &
	inotifywait -e create,modify "${CONFIG_FILES[@]}"
done

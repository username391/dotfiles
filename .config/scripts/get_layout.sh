#!/bin/bash

# FIXME: Предполагается, что стоит линукс (hyprland или что-то с xkb),
# в будущем нужно будет сделать проверку
if command -v hyprctl &> /dev/null; then
  layout=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap' 2>/dev/null)
else
	# Fallback: X11/Wayland common method
	layout=$(setxkbmap -query | awk '/layout/{print $2}')
fi

case "$layout" in
  *us*|*US*) echo "us" ;;
  *ru*|*RU*) echo "ru" ;;
  *) echo "$layout" ;;
esac

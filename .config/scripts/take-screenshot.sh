#!/bin/bash
# Screenshot helper for Hyprland.
#   Print              -> save screenshot of the focused monitor
#   SHIFT + Print      -> copy screenshot of the focused monitor to clipboard
#   ALT + Print        -> save a cropped region
#   ALT + SHIFT + Print-> copy a cropped region to clipboard
#
# Requires: grim, slurp, wl-clipboard (wl-copy), libnotify (notify-send).

set -u

# grim/slurp are installed in ~/.local/bin on this machine.
export PATH="$HOME/.local/bin:$PATH"

use_clipboard=false
crop=false
filetype="png"
output_dir="$HOME/Pictures/screenshots"
icon="$HOME/.config/swaync/icons/picture.png"

for arg in "$@"; do
	case "$arg" in
		--clipboard) use_clipboard=true ;;
		--crop) crop=true ;;
	esac
done

if ! command -v grim >/dev/null 2>&1; then
	notify-send -u critical "Скриншот не сделан" "Не установлен grim. Установи: sudo pacman -S grim slurp"
	exit 1
fi

if [ "$crop" = true ] && ! command -v slurp >/dev/null 2>&1; then
	notify-send -u critical "Скриншот не сделан" "Не установлен slurp. Установи: sudo pacman -S grim slurp"
	exit 1
fi

mkdir -p "$output_dir"

capture_args=(-t "$filetype")

if [ "$crop" = true ]; then
	geometry=$(slurp) || exit 0
	[ -n "$geometry" ] || exit 0
	capture_args+=(-g "$geometry")
else
	# Monitor of the currently active workspace.
	monitor=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.monitor // empty')
	if [ -n "$monitor" ]; then
		capture_args+=(-o "$monitor")
	fi
fi

if [ "$use_clipboard" = true ]; then
	if grim "${capture_args[@]}" - | wl-copy --type "image/$filetype"; then
		notify-send -i "$icon" "Скриншот скопирован"
		"$HOME/.config/hypr/scripts/sounds.sh" --screenshot >/dev/null 2>&1 || true
	else
		notify-send -u critical "Скриншот не сделан"
		exit 1
	fi
else
	filename="$(date +'%d-%m-%Y_%H-%M-%S').$filetype"
	filepath="$output_dir/$filename"

	if grim "${capture_args[@]}" "$filepath"; then
		notify-send -i "$icon" "Скриншот сохранён: $filename" "$filepath"
		printf '%s\n' "$filepath"
		"$HOME/.config/hypr/scripts/sounds.sh" --screenshot >/dev/null 2>&1 || true
	else
		notify-send -u critical "Скриншот не сделан"
		exit 1
	fi
fi

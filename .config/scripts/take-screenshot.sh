#!/bin/bash

# Проверяем наличие аргумента --clipboard
to_clipboard=false
crop=false
filetype="jpeg"
quality=80

for arg in "$@"; do
	if [ "$arg" == "--clipboard" ]; then
		use_clipboard=true
		break
	fi
done

for arg in "$@"; do
	if [ "$arg" == "--crop" ]; then
		crop=true
		break
	fi
done

# Если папки нет, создаем ее
mkdir -p ~/Pictures/screenshots

if [ "$use_clipboard" = true ]; then
	if [ "$crop" = true ]; then
		grim -t "$filetype" -q "$quality" -g "$(slurp)" - | wl-copy --type image/"$filetype"
	else
		grim -t "$filetype" -q "$quality" -o "$(hyprctl monitors | awk '/Monitor/{mon=$2} /focused: yes/{print mon}')" - | wl-copy --type/"$filetype"
	fi
	notify-send "Скриншот скопирован"
else
	filename="$(date +'%d-%m-%Y_%H-%M-%S').png"
	filepath="$HOME/Pictures/screenshots/$filename"

	if [ "$crop" = true ]; then
		grim -t "$filetype" -q "$quality" -g "$(slurp)" "$filepath"
	else
		grim -t "$filetype" -q "$quality" -o "$(hyprctl monitors | awk '/Monitor/{mon=$2} /focused: yes/{print mon}')" "$filepath"
	fi
	notify-send "Скриншот сохранен: $filename" -h string:action:open:"imv $filepath"
	echo "$filepath"
fi

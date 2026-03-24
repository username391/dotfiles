#!/bin/bash

set -e

filename=""
loaded=false

# Если нужно загрузить filename из кэша - делаем это здесь
for arg in "$@"; do
	if [ "$arg" == "--load" ]; then
		filename=$(cat ~/.cache/wallpaper)
		loaded=true
		break
	fi
done

# Проверяем, есть ли аргумент, но только если $filename уже не задан из кэша
if [ -z "$filename" ]; then
	if [ -z "$1" ]; then
		notify-send.sh --replace-file ~/.cache/91222 "No file passed!"
		echo "No file passed!"
		exit 1
	else
		filename="$1"
	fi
fi

# Если нужно сохранить файл - сохраняем
for arg in "$@"; do
	if [ "$arg" == "--save" ]; then
		echo "$filename" >~/.cache/wallpaper
		break
	fi
done

# Проверка существует ли файл
if [ ! -f $filename ]; then
	notify-send.sh --replace-file ~/.cache/91222 "File $filename does not exist"
	echo "File $filename does not exist"
	exit 1
fi

if [[ "$loaded" == false ]]; then
	notify-send.sh --replace-file ~/.cache/91222 "wallpaper changed sww" "$(basename "$filename")" -i "image-jpeg" -a "wallpaper-change"
fi

# Устанавливаем обои
# NOTE: Почему то после обновления unload all, preload больше не работают
# нужно будет посмотреть, может теперь это и не нужно больше
# hyprctl hyprpaper unload all
# hyprctl "hyprpaper preload $filename"
# hyprctl "hyprpaper wallpaper ,$filename"
# hyprctl hyprpaper wallpaper '[mon], [path], [fit_mode]'
# hyprctl hyprpaper wallpaper ,$filename

swww img "$filename" --transition-type="wipe" --transition-duration="0.5"

# wal -i $filename -s -t

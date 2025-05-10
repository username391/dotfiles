#!/bin/bash

set -e

filename=""

# Если нужно загрузить filename из кэша - делаем это здесь
for arg in "$@"; do
	if [ "$arg" == "--load" ]; then
		filename=$(cat ~/.cache/wallpaper)
		break
	fi
done

# Проверяем, есть ли аргумент, но только если $filename уже не задан из кэша
if [ -z "$filename" ]; then
	if [ -z "$1" ]; then
		notify-send.sh --replace-file 91222 "No file passed!"
		echo "No file passed!"
		exit 1
	else
		filename="$1"
	fi
fi


# Если нужно сохранить файл - сохраняем
for arg in "$@"; do
	if [ "$arg" == "--save" ]; then
		echo "$filename" > ~/.cache/wallpaper
		break
	fi
done

# Проверка существует ли файл
if [ ! -f $filename ]; then
	notify-send.sh --replace-file 91222 "File $filename does not exist"
	echo "File $filename does not exist"
	exit 1
fi

notify-send.sh --replace-file 91222 "wallpaper changed" "$(basename "$filename")" -i "image-jpeg" -a "wallpaper-change"

# Устанавливаем обои
hyprctl hyprpaper unload all
hyprctl "hyprpaper preload $filename"
hyprctl "hyprpaper wallpaper ,$filename"


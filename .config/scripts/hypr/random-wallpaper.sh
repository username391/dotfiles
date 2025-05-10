#!/bin/bash

set -e

# Проверяем, есть ли аргумент
if [ -z "$1" ]; then
	notify-send "No directory passed!"
	echo "No directory passed!"
	exit 1
fi

# Проверка существует ли директория
if [ ! -d "$1" ]; then
	notify-send "Directory does not exist"
	echo "Directory does not exist"
	exit 1
fi

# Получаем случайный файл
filename=`/bin/ls $1/ | xargs -n 1 basename | shuf -n 1`

~/.config/scripts/hypr/set-wallpaper.sh "$1/$filename" --save

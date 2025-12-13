#!/bin/bash

# FIXME: Это для клавиатуры ноута, а следующая для главной
layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name == "at-translated-set-2-keyboard") | .active_keymap' | cut -c 1-2 | tr 'A-Z' 'a-z')

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | cut -c 1-2 | tr 'A-Z' 'a-z')

if [ "$layout" == "en" ]; then
	echo "🇺🇸 "
elif [ "$layout" == "ru" ]; then
	echo "🇷🇺 "
else
	echo "$layout 🇦🇾"
fi

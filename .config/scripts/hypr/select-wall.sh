#!/usr/bin/env bash

WALLPAPERS_PATH=~/__wallpapers
echo WALLPAPERS_PATH


NEW_WALL=$(ls $WALLPAPERS_PATH | wofi -dmenu --allow-images true)

~/.config/scripts/hypr/set-wallpaper.sh "$WALLPAPERS_PATH/$NEW_WALL"


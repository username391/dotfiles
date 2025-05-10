#!/usr/bin/env bash

killall waybar
waybar &>/dev/null & disown

killall hyprpaper
hyprpaper &>/dev/null &disown

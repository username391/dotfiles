#!/bin/bash

case "$1" in
    *.jpg|*.jpeg|*.png|*.gif|*.bmp)
        imv "$1" ;;
    *.mp4|*.mkv|*.webm|*.avi)
        mpv "$1" ;;
	*.py|*.c|*.cpp|*.md)
		nvim "$1" ;;
    *)
        xdg-open "$1" ;;
esac


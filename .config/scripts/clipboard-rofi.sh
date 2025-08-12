#!/usr/bin/bash

# pacman -S clipmenu


rofi_clipboard() {
  rofi -config "$HOME/.config/rofi/config.rasi -show drun"
}
export -f rofi_clipboard

env CM_LAUNCHER=rofi_clipboard clipmenu

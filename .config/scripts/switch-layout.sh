#!/bin/bash

DEVICE="at-translated-set-2-keyboard"
CURRENT=$(hyprctl devices | awk "/$DEVICE/{found=1} found&&/active layout:/{print \$NF; exit}")

if [ "$CURRENT" = "0" ]; then
  hyprctl switchxkblayout "$DEVICE" 1
else
  hyprctl switchxkblayout "$DEVICE" 0
fi


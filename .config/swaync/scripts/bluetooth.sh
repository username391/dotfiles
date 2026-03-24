#!/usr/bin/env bash

# Проверяем, включён ли Bluetooth
if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
	echo " OFF"
	exit 0
fi

# Ищем подключённое устройство
DEVICE=$(bluetoothctl devices Connected | head -n1)

if [ -z "$DEVICE" ]; then
	echo " ON"
	exit 0
fi

MAC=$(echo "$DEVICE" | awk '{print $2}')
NAME=$(echo "$DEVICE" | cut -d' ' -f3-)

# Пытаемся получить батарею
BATTERY=$(bluetoothctl info "$MAC" | grep -i "Battery Percentage" | awk -F'[()]' '{print $2}')

if [ -n "$BATTERY" ]; then
	echo " ON · $NAME · $BATTERY%"
else
	echo " ON · $NAME"
fi

#!/bin/bash
source "/home/me/.config/scripts/vars.sh"

# 🔧 MAC-адрес твоих наушников (можно узнать через bluetoothctl -> devices)
# BT_DEVICE_MAC="XX:XX:XX:XX:XX:XX"

# 🔍 Проверка текущего статуса устройства
connected=$(bluetoothctl info "$BT_DEVICE_MAC" | grep "Connected: yes")

if [ -n "$connected" ]; then
	bluetoothctl disconnect "$BT_DEVICE_MAC" | grep -i "successful" >/dev/null
	echo "🎧 Наушники подключены. Отключаю..."
	notify-send.sh "🎧 Наушники подключены. Отключаю..."
else
	bluetoothctl connect "$BT_DEVICE_MAC" | grep -i "successful" >/dev/null
	echo "🎧 Наушники не подключены. Подключаю..."
	notify-send.sh "🎧 Наушники не подключены. Подключаю..."
fi

#!/bin/bash
# Скрипт нужно будет переименовать

powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$powered" = "yes" ]; then
	bluetoothctl power off
	echo "📴 Bluetooth выключен"
	notify-send.sh "📴 Bluetooth выключен"
else
	bluetoothctl power on
	echo "📡 Bluetooth включен"
	notify-send.sh "📡 Bluetooth включен"
fi

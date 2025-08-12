#!/bin/bash

# Получить список PID всех окон, управляемых Hyprland
window_pids=$(hyprctl clients -j | jq -r '.[].pid' | sort -u)

if [ -z "$window_pids" ]; then
    echo "Нет окон для закрытия."
    exit 0
fi

echo "Закрываю следующие PID окон:"
echo "$window_pids"

# Принудительно убить все процессы окон
for pid in $window_pids; do
    kill -9 "$pid" 2>/dev/null && echo "Убито: $pid"
done


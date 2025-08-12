#!/usr/bin/env bash

CONFIG="$HOME/.ssh/config"

# Проверим наличие fzf
if ! command -v fzf &>/dev/null; then
	echo "fzf не установлен. Установите его сначала (например: sudo apt install fzf)"
	exit 1
fi

# Собираем список хостов с комментариями
hosts=$(awk '
    /^#/{comment=$0; next}
    /^Host / {
        host=$2;
        if (comment) {
            printf "%-20s %s\n", host, comment;
            comment="";
        } else {
            printf "%s\n", host;
        }
    }
' "$CONFIG")

# Показываем в fzf
selected=$(echo "$hosts" | fzf --prompt="Выберите сервер: " | awk '{print $1}')

# Выход если ничего не выбрано
[ -z "$selected" ] && exit 0

# Подключение
ssh -t "$selected"

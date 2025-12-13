#!/usr/bin/env bash

CONFIG="$HOME/.ssh/config"

# Проверим наличие fzf
if ! command -v fzf &>/dev/null; then
	echo "fzf не установлен. Установи его, чтобы использовать скрипт"
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
if [ "$1" == "sftp" ]; then
	sftp "$selected"
else
	ssh -t "$selected"
fi

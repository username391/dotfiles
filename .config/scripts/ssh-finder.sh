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

# Показываем в fzf с циклической навигацией
selected=$(echo "$hosts" | fzf --cycle --prompt="Выберите сервер: " | awk '{print $1}')

# Выход если ничего не выбрано
[ -z "$selected" ] && exit 0

# Функция для выбора типа подключения
show_connection_menu() {
	echo "1) SSH"
	echo "2) SFTP"
	echo "3) Port Forward (проброс порта)"
	echo "4) SOCKS5 Proxy (динамический туннель)"
	echo ""
	read -p "Выберите тип подключения (1-4): " choice
	echo "$choice"
}

# Функция для проброса порта
port_forward() {
	local host=$1
	read -p "Удалённый порт на сервере: " remote_port
	read -p "Локальный порт (Enter для такого же): " local_port

	# Если локальный порт не указан, используем удалённый
	[ -z "$local_port" ] && local_port=$remote_port

	echo "Пробрасываем порт: localhost:$local_port -> $host:$remote_port"
	echo "Для завершения нажмите Ctrl+C"
	ssh -L "$local_port:localhost:$remote_port" -N "$host"
}

# Функция для SOCKS5 прокси
socks_proxy() {
	local host=$1
	read -p "Локальный порт для SOCKS5 прокси (по умолчанию 1080): " proxy_port

	# Если порт не указан, используем 1080
	[ -z "$proxy_port" ] && proxy_port=1080

	echo "Запускаем SOCKS5 прокси на localhost:$proxy_port"
	echo "Настройте браузер/приложение на использование SOCKS5 прокси: localhost:$proxy_port"
	echo "Для завершения нажмите Ctrl+C"
	ssh -D "$proxy_port" -N "$host"
}

# Обработка аргументов командной строки или меню
if [ "$1" == "sftp" ]; then
	sftp "$selected"
elif [ "$1" == "forward" ] || [ "$1" == "port" ]; then
	port_forward "$selected"
elif [ "$1" == "socks" ] || [ "$1" == "proxy" ]; then
	socks_proxy "$selected"
elif [ -z "$1" ]; then
	# Если аргументов нет, показываем меню
	choice=$(show_connection_menu)

	case $choice in
	1)
		ssh -t "$selected"
		;;
	2)
		sftp "$selected"
		;;
	3)
		port_forward "$selected"
		;;
	4)
		socks_proxy "$selected"
		;;
	*)
		echo "Неверный выбор"
		exit 1
		;;
	esac
else
	# По умолчанию SSH
	ssh -t "$selected"
fi

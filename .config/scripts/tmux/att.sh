#!/bin/bash

source "/home/me/.config/scripts/vars.sh"

# Этот скрипт подключается к сессии tmux,
# если сессия с таким названием существует
# Также совершает некоторые действия для сессий
# с определенными называниями

if [ "$1" == "work" ]; then
	tmux new-session -c "$WORK_DIR" -A -s work
elif [ "$1" == "config" ]; then
	tmux new-session -c "$CONFIG_DIR" -A -s config
elif [ "$1" == "" ]; then
	# Если название не передано - пробуем
	# подключиться к последней сессии
	tmux att
else
	tmux new-session -A -s "$1"
fi

# alias att='tmux new-session -A -s'

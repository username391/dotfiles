#!/bin/bash

WINDOW_INDEX=1
SESSION_NAME=misc

# Create session if does not exist
tmux new-session -D -s "$SESSION_NAME"

# Switch to first pane
# tmux select-window -t "$SESSION_NAME:$WINDOW_INDEX"

# Проверяем запущен ли pyradio, если нет - запускаем
pane_text=$(tmux capture-pane -pt "$SESSION_NAME:$WINDOW_INDEX")

# Проверить наличие слова pyradio
if echo "$pane_text" | grep -qE "\[stations\]"; then
    echo "pyradio уже запущен в окне $WINDOW_INDEX"
else
    echo "pyradio не обнаружен, запускаю"
	tmux send-keys -t "$SESSION_NAME:$WINDOW_INDEX" "pyradio"
	tmux send-keys -t "$SESSION_NAME:$WINDOW_INDEX" C-m
fi


tmux send-keys -t "$SESSION_NAME:$WINDOW_INDEX" "Gk "
# tmux send-keys -t "$SESSION_NAME:$WINDOW_INDEX" " "

echo "Готово!"

#!/bin/bash

# Получаем текущую громкость (через pamixer)
volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

bar="   $(seq -s "─" $(($volume/4)) | sed 's/[0-9]//g')  "

if [ "$mute" = "true" ]; then
    notify-send.sh --replace-file ~/.cache/91191 "     Muted\n$bar"
else

	if [ "$volume" -le 33 ]; then
		notify-send.sh --replace-file ~/.cache/91191 "    Volume: $volume% \n$bar"
	elif [ "$volume" -le 66 ]; then
		notify-send.sh --replace-file ~/.cache/91191 "    Volume: $volume% \n$bar"
	else
		notify-send.sh --replace-file ~/.cache/91191 "     Volume: $volume% \n$bar"
	fi
fi

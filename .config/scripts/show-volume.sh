
#!/bin/bash

# Получаем текущую громкость (через pamixer)
volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
    notify-send.sh --replace-file ~/.cache/91191 "  Muted"
else
	if [ "$volume" -le 33 ]; then
		notify-send.sh --replace-file ~/.cache/91191 " Volume: $volume%"
	elif [ "$volume" -le 66 ]; then
		notify-send.sh --replace-file ~/.cache/91191 " Volume: $volume%"
	else
		notify-send.sh --replace-file ~/.cache/91191 "  Volume: $volume%"
	fi
fi

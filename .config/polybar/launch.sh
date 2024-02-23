#!/bin/bash


killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar mainbar &

echo "Polybar загрузился..."

# hide polybar if --hidden arg passed
if [[ $@ == *'--hidden'* ]]; then
	(xdo id -m -N Polybar && polybar-msg cmd hide)&
fi


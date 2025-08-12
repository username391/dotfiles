#!/bin/bash


read_file() {
	local file="$1"
	local defaultValue="$2"
	local file=$(eval echo "$file")

	if [[ -f "$file" ]]; then
		local content
		content=$(<"$file")

		if [[ -n "$content" && "$content" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
			echo "$content"
		else
			echo "$defaultValue" > "$file"
			echo "$defaultValue"
		fi
	else
		echo "$defaultValue" > "$file"
		echo "$defaultValue"
	fi
}

temperature=$(read_file "~/.cache/gammastep_temperature" "3000" )
oldpic=$(read_file "~/.cache/gammastep_pid" "79874" )

temperature=$((temperature + $1))


if [ $temperature -gt 6500 ]; then
	temperature=6500
elif [ $temperature -lt 3000 ]; then
	temperature=3000
fi


echo "$temperature"
echo $temperature > ~/.cache/gammastep_temperature
# exec gammastep -Pr -O $temperature &
gammastep -O $temperature &
# pid=$!
# echo $pid > ~/.cache/gammastep_pid
# kill $oldpid

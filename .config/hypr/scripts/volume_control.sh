#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic.
#
# Uses wpctl (PipeWire/WirePlumber) instead of pamixer, because pamixer is
# not installed on this system.

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts/"

SINK="@DEFAULT_AUDIO_SINK@"
SOURCE="@DEFAULT_AUDIO_SOURCE@"

get_raw() {
	wpctl get-volume "$1" 2>/dev/null
}

is_muted() {
	get_raw "$1" | grep -q '\[MUTED\]'
}

get_percent() {
	local raw value
	raw=$(get_raw "$1")
	value=$(awk '/Volume:/{print $2}' <<<"$raw")
	[[ -z "$value" ]] && return 1
	awk -v v="$value" 'BEGIN { printf "%d", v * 100 + 0.5 }'
}

# Get Volume
get_volume() {
	local pct
	if ! pct=$(get_percent "$SINK"); then
		echo "N/A"
	elif is_muted "$SINK" || [[ "$pct" -eq 0 ]]; then
		echo "Muted"
	else
		echo "${pct}%"
	fi
}

# Get icons
get_icon() {
	local current
	current=$(get_volume)
	if [[ "$current" == "Muted" || "$current" == "N/A" ]]; then
		echo "$iDIR/volume-mute.png"
	elif [[ "${current%\%}" -le 30 ]]; then
		echo "$iDIR/volume-low.png"
	elif [[ "${current%\%}" -le 60 ]]; then
		echo "$iDIR/volume-mid.png"
	else
		echo "$iDIR/volume-high.png"
	fi
}

# Notify
# notify_user() {
	# NOTE: disabled, noctalia does this
	# if [[ "$(get_volume)" == "Muted" ]]; then
	# 	notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: Muted"
	# else
	# 	notify-send -e \
	# 		-h string:x-canonical-private-synchronous:volume_notif \
	# 		-u low -i "$(get_icon)" \
	# 		"Volume: $(get_volume)"
	#
	# 	"$sDIR/sounds.sh" --volume >/dev/null 2>&1 || true
	# fi
# }

# Increase Volume
inc_volume() {
	if is_muted "$SINK"; then
		wpctl set-mute "$SINK" 0
	fi
	wpctl set-volume -l 1.0 "$SINK" 5%+ && notify_user
}

# Decrease Volume
dec_volume() {
	if is_muted "$SINK"; then
		wpctl set-mute "$SINK" 0
	fi
	wpctl set-volume "$SINK" 5%- && notify_user
}

# Toggle Mute
toggle_mute() {
	wpctl set-mute "$SINK" toggle
	if is_muted "$SINK"; then
		notify-send -e -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
	else
		notify-send -e -u low -i "$(get_icon)" "Volume Switched ON"
	fi
}

# Toggle Mic
toggle_mic() {
	wpctl set-mute "$SOURCE" toggle
	if is_muted "$SOURCE"; then
		notify-send -e -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
	else
		notify-send -e -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
	fi
}

# Get Mic Icon
get_mic_icon() {
	local pct
	if ! pct=$(get_percent "$SOURCE"); then
		echo "$iDIR/microphone-mute.png"
	elif is_muted "$SOURCE" || [[ "$pct" -eq 0 ]]; then
		echo "$iDIR/microphone-mute.png"
	else
		echo "$iDIR/microphone.png"
	fi
}

# Get Microphone Volume
get_mic_volume() {
	local pct
	if ! pct=$(get_percent "$SOURCE"); then
		echo "N/A"
	elif is_muted "$SOURCE" || [[ "$pct" -eq 0 ]]; then
		echo "Muted"
	else
		echo "${pct}%"
	fi
}

# Notify for Microphone
notify_mic_user() {
	local volume icon value
	volume=$(get_mic_volume)
	icon=$(get_mic_icon)

	if [[ "$volume" == "Muted" || "$volume" == "N/A" ]]; then
		notify-send -e -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "$icon" "Mic-Level: $volume"
	else
		value="${volume%\%}"
		notify-send -e -h int:value:"$value" -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "$icon" "Mic-Level: $volume"
	fi
}

# Increase MIC Volume
inc_mic_volume() {
	if is_muted "$SOURCE"; then
		wpctl set-mute "$SOURCE" 0
	fi
	wpctl set-volume -l 1.0 "$SOURCE" 5%+ && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
	if is_muted "$SOURCE"; then
		wpctl set-mute "$SOURCE" 0
	fi
	wpctl set-volume "$SOURCE" 5%- && notify_mic_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi

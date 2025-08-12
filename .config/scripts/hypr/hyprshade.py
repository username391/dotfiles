#!/bin/python
import os
import sys

state_file = '/home/me/.cache/hyprshade-state'
# state == "on" or "off"


def write_state(value: str):
    with open(state_file, 'w') as f:
        f.write(value)


def read_state() -> str:
    with open(state_file, 'r') as f:
        return f.read()

if not os.path.isfile(state_file):
    write_state('on')

current_state = read_state()


if '--state' in sys.argv:
    if current_state == 'on':
        print('on')
        sys.exit(1)


if '--restore' in sys.argv:
    new_state = current_state

else:
    # Если аргументы не указаны, тогда как воспринимаем как toggle
    new_state = 'on' if current_state == 'off' else 'off'
    write_state(new_state)


if new_state == 'on':
    os.system('hyprshade on blue-light-filter')
else:
    os.system('hyprshade off')


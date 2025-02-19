#!/bin/zsh

# Проверяем, является ли текущая ОС Ubuntu
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ $ID == "ubuntu" ]]; then
        # Если ОС Ubuntu, назначаем алиас
        # alias python='python3'
        echo "Алиас 'python' назначен на 'python3'."
    else
        echo "Текущая ОС не является Ubuntu."
    fi
else
    echo "Не удалось определить операционную систему."
fi

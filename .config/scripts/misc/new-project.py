#!/bin/python

import time
import sys
import pathlib


def main():
    if len(sys.argv) < 2:
        print("Введи название проекта!")
        return

    # Создаем новую директорию
    project_path = pathlib.Path(sys.argv[1])

    try:
        project_path.mkdir(parents=True, exist_ok=False)
    except FileExistsError:
        print("Директория проекта уже существует!")
        return

    # Создаем мета файл с информацией о проекте
    meta_file = pathlib.Path(project_path, ".meta")

    try:
        meta_file.touch(exist_ok=False)
    except FileExistsError:
        # Хотя этого быть не должно, он только что создал папку
        print("Мета файл уже существует!")
        return

    # Записываем основую информацию
    meta_data = f"Created: {time.strftime('%Y-%m-%d %H:%M:%S')}\nCreated UnixTime: {int(time.time())}"

    with meta_file.open(mode="w") as f:
        f.write(meta_data)

    # TODO: Не знаю как именно перейти в директорию
    # os.system(f"cd {project_path.resolve()}")


if __name__ == "__main__":
    main()

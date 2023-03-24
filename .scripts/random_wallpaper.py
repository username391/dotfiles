import os
import random

from config import WALLPAPERS_DIR


def get_random_wallpaper(directory: str = WALLPAPERS_DIR) -> str:
    # get all files in directory
    files = os.listdir(directory)
    # choose random file
    file = random.choice(files)
    # concat filename and directory and return
    return os.path.join(directory, file)


if __name__ == '__main__':
    random_file = get_random_wallpaper()
    print(random_file)


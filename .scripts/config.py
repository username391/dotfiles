import os
import pathlib

HOME_DIR: str = os.path.expanduser('~')
PICTURES_DIR: str = os.path.join(HOME_DIR, 'Pictures')
WALLPAPERS_DIR: str = os.path.join(PICTURES_DIR, 'wallpapers')
TEMP_IMAGE_DIR: str = os.path.join(PICTURES_DIR, 'temporary')


# create paths, if they do not exist
pathlib.Path(WALLPAPERS_DIR).mkdir(exist_ok=True)
pathlib.Path(TEMP_IMAGE_DIR).mkdir(exist_ok=True)

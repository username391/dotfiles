import os

from PIL import Image, ImageFilter
from config import TEMP_IMAGE_DIR


SCREENSHOT_PATH = os.path.join(TEMP_IMAGE_DIR, 'screenshot.png')
BLURED_SCREENSHOT_PATH = os.path.join(TEMP_IMAGE_DIR, 'blured_screenshot.png')


os.system(f'scrot -f {SCREENSHOT_PATH} -z -o')

# bluring with pillow
image = Image.open(SCREENSHOT_PATH)
image = image.filter(ImageFilter.BoxBlur(50))
image.save(BLURED_SCREENSHOT_PATH)

# printing BLURED_SCREENSHOT_PATH for other script to use
print(BLURED_SCREENSHOT_PATH)

from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

config: ConfigAPI = config
c: ConfigContainer = c

BACKGROUND = "#1E1E2E"
FOREGROUND = "#CDD6F4"
ACTIVE = "#94E2D5"
YELLOW = "#F9E2AF"
GREEN = "#A6E3A1"
BLACK = "#45475A"
BLUE = "#89B4FA"

config.load_autoconfig(False)

c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}

# Setting dark mode
config.set("colors.webpage.darkmode.enabled", True)
# hide tabs if there is only one
config.set("tabs.show", "multiple")

config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set("content.javascript.clipboard", "access")

c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "im": "https://images.yandex.ru/?q={}"
}
c.url.start_pages = c.url.default_page

c.colors.completion.fg = ['#9cc4ff', FOREGROUND, FOREGROUND]


c.tabs.position = "bottom"
c.backend = "webengine"
c.content.blocking.method = "both"
c.downloads.position = "bottom"
c.downloads.remove_finished = 5000
c.fonts.default_size = "10pt"
c.hints.auto_follow = "unique-match"
c.hints.auto_follow_timeout = 700
# c.hints.mode = "number"
# c.input.insert_mode.auto_enter = True
# c.input.insert_mode.auto_leave = True
# c.input.insert_mode.auto_load = True
c.tabs.background = False
c.tabs.last_close = "close"
c.tabs.show = "always"
c.url.default_page = "https://google.com"
c.zoom.default = 100

c.colors.completion.fg = ['#9cc4ff', FOREGROUND, FOREGROUND]
c.colors.completion.odd.bg = BLACK
c.colors.completion.even.bg = BLACK
c.colors.completion.category.fg = '#e1acff'

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #000000, stop:1 #232429)'

c.colors.completion.category.border.top = BLACK
c.colors.completion.category.border.bottom = BLACK
c.colors.completion.item.selected.fg = BACKGROUND
c.colors.completion.item.selected.bg = YELLOW
c.colors.completion.item.selected.match.fg = '#c678dd'
c.colors.completion.match.fg = '#c678dd'
c.colors.completion.scrollbar.fg = FOREGROUND
c.colors.downloads.bar.bg = BACKGROUND
c.colors.downloads.error.bg = '#ff6c6b'
c.colors.hints.fg = BACKGROUND
c.colors.hints.match.fg = GREEN

c.colors.messages.info.bg = BACKGROUND
c.colors.statusbar.normal.bg = BACKGROUND
c.colors.statusbar.insert.fg = FOREGROUND
c.colors.statusbar.insert.bg = BACKGROUND
c.colors.statusbar.passthrough.bg = BLACK

c.colors.statusbar.command.bg = BACKGROUND
c.colors.statusbar.url.warn.fg = YELLOW
c.colors.tabs.bar.bg = BACKGROUND
c.colors.tabs.odd.bg = BACKGROUND
c.colors.tabs.even.bg = BACKGROUND
c.colors.tabs.odd.fg = FOREGROUND
c.colors.tabs.even.fg = FOREGROUND
c.colors.tabs.selected.odd.bg = ACTIVE
c.colors.tabs.selected.even.bg = ACTIVE
c.colors.tabs.selected.odd.fg = BLACK
c.colors.tabs.selected.even.fg = BLACK

c.colors.tabs.pinned.odd.bg = BLUE
c.colors.tabs.pinned.even.bg = BLUE
c.colors.tabs.pinned.selected.odd.bg = BACKGROUND
c.colors.tabs.pinned.selected.even.bg = BACKGROUND

# Default font families to use. Whenever "default_family" is used in a
# font setting, it's replaced with the fonts listed here. If set to an
# empty value, a system-specific monospace default is used.
# Type: List of Font, or Font
c.fonts.default_family = '"Source Code Pro"'

# Default font size to use. Whenever "default_size" is used in a font
# setting, it's replaced with the size listed here. Valid values are
# either a float value with a "pt" suffix, or an integer value with a
# "px" suffix.
# Type: String
c.fonts.default_size = '11pt'

# Font used in the completion widget.
# Type: Font
c.fonts.completion.entry = '11pt "Source Code Pro"'

# Font used for the debugging console.
# Type: Font
c.fonts.debug_console = '11pt "Source Code Pro"'

# Font used for prompts.
# Type: Font
c.fonts.prompts = 'default_size sans-serif'

# Font used in the statusbar.
# Type: Font
c.fonts.statusbar = '11pt "Source Code Pro"'


# binds
config.bind("M", "hint links spawn mpv {hint-url}")
config.bind("xM", "spawn mpv {url}")
config.bind("xb", "config-cycle statusbar.show always never")
config.bind("xt", "config-cycle tabs.show multiple never")
config.bind("xx", "config-cycle statusbar.show always never;;config-cycle tabs.show multiple never")

config.bind("xD", "hint links spawn python /home/me/pro/download.py {hint-url}")


import json

from ignis.app import IgnisApp
from ignis.utils import Utils
from side_sliders.volume import Volume
from side_sliders.backlight import Backlight
from control.control import Controller


try:
    with open(
        ".config/ignis/scripts/control_scripts.json",
        "r",
        encoding="UTF-8",
    ) as f:
        BASH_COMMANDS = json.load(f)
except FileNotFoundError as e:
    print(e)
    BASH_COMMANDS = {}

app = IgnisApp.get_default()
app.apply_css(f"{Utils.get_current_dir()}/style.scss")

# Set up volume slider
volume = Volume()

# Set up backlight
backlight = Backlight()

# Control panel
controller = Controller(BASH_COMMANDS)

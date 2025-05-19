import asyncio
from ignis.app import IgnisApp
from ignis.utils import Utils

from volume import Volume
from backlight import Backlight
from control import Controller


app = IgnisApp.get_default()
app.apply_css(f"{Utils.get_current_dir()}/style.scss")

# Set up volume slider
volume = Volume()
volume.create_window()

# Set up backlight
backlight = Backlight()
backlight.create_window()

# controller = Controller()
# controller.create_window()
# asyncio.create_task(controller.waiter())

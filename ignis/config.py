import asyncio
from ignis.app import IgnisApp
from ignis.utils import Utils

from volume import Volume
from backlight import Backlight


app = IgnisApp.get_default()
app.apply_css(f"{Utils.get_current_dir()}/style.scss")

# Set up volume slider
volume = Volume()
volume.create_window()
asyncio.create_task(volume.waiter())

# Set up backlight
backlight = Backlight()
backlight.create_window()
asyncio.create_task(backlight.waiter())

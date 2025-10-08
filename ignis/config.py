from ignis.app import IgnisApp
from ignis.utils import Utils

from side_sliders.volume import Volume
from side_sliders.backlight import Backlight
from control.control import Controller


app = IgnisApp.get_default()
app.apply_css(f"{Utils.get_current_dir()}/style.scss")

# Set up volume slider
volume = Volume()

# Set up backlight
backlight = Backlight()

controller = Controller()

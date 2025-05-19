import asyncio
from ignis.widgets import Widget
from ignis.services.backlight import BacklightService
from ignis.utils import debounce


class Backlight:
    def __init__(self):
        self.backlight = BacklightService.get_default()

        self.light_icon = self.get_light_icon()
        self.light_slider = self.get_light_slider()
        self.light_revealer = self.get_light_revealer()

    def get_light_icon(self) -> Widget.Box:
        return Widget.Box(
            child=[
                Widget.Icon(
                    image="display-brightness-symbolic",
                )
            ],
            css_classes=["volume-icon"],
        )

    def get_light_slider(self):
        return Widget.Scale(
            vertical=True,
            min=0,
            max=self.backlight.max_brightness + 300,
            step=1,
            value=self.backlight.bind("brightness"),
            css_classes=["metric"],
        )

    def get_light_revealer(self):
        return Widget.Revealer(
            child=Widget.Box(
                vertical=True,
                child=[
                    self.light_slider,
                    self.light_icon,
                ],
                css_classes=["volume"],
            ),
            transition_type="crossfade",
            transition_duration=200,
            reveal_child=False,
        )

    def create_window(self, monitor_id: int = 0) -> Widget.Window:
        return Widget.Window(
            namespace=f"ignis_backlight_{monitor_id}",
            monitor=monitor_id,
            anchor=["left"],
            child=self.light_revealer,
        )

    def start_light(self):
        self.light_revealer.reveal_child = True
        self.end_light()

    @debounce(1500)
    def end_light(self):
        self.light_revealer.reveal_child = False

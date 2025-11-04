from ignis.widgets import Widget, Box
from ignis.services.backlight import BacklightService


class BacklightWidget(Box):
    def __init__(self, BACH_COMMANDS: dict):
        self.backlight = BacklightService.get_default()
        super().__init__(
            child=[
                Widget.Button(
                    child=Widget.Icon(
                        image="display-brightness-symbolic",
                    ),
                    css_classes=["battery", "disableHover"],
                ),
                Widget.Scale(
                    vertical=False,
                    min=0,
                    max=self.backlight.max_brightness,
                    step=10,
                    value=self.backlight.bind("brightness"),
                    on_change=lambda x: self.backlight.set_brightness(x.value),
                    css_classes=["control-metric"],
                    hexpand=True,
                ),
            ]
        )

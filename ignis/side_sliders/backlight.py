from ignis.widgets import Widget
from ignis.services.backlight import BacklightService
from ignis.utils import debounce


class Backlight(Widget.RevealerWindow):
    def __init__(self):
        self.backlight = BacklightService.get_default()

        revealer = Widget.Revealer(
            child=Widget.Box(
                vertical=True,
                child=[
                    Widget.Scale(
                        vertical=True,
                        min=0,
                        max=self.backlight.max_brightness + 300,
                        step=1,
                        value=self.backlight.bind("brightness"),
                        css_classes=["metric"],
                    ),
                    Widget.Box(
                        child=[
                            Widget.Icon(
                                image="display-brightness-symbolic",
                            )
                        ],
                        css_classes=["volume-icon"],
                    ),
                ],
                css_classes=["volume"],
            ),
            transition_type="crossfade",
            transition_duration=400,
            reveal_child=True,
        )

        super().__init__(
            visible=False,
            popup=True,
            layer="top",
            anchor=["left"],
            namespace="ignis_backlight",
            child=Widget.Box(child=[revealer]),
            revealer=revealer,
        )

    def start_light(self):
        self.visible = True
        self.end_light()

    @debounce(1500)
    def end_light(self):
        print("yeye")
        self.visible = False

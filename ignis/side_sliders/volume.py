from ignis.widgets import Widget
from ignis.services.audio import AudioService
from ignis.utils import debounce


class Volume(Widget.RevealerWindow):
    def __init__(self):
        self.audio = AudioService.get_default()
        self.volume_slider = Widget.Scale(
            vertical=True,
            min=-27,
            max=125,
            step=1,
            value=self.audio.speaker.bind("volume"),
            css_classes=["metric"],
        )

        revealer = Widget.Revealer(
            child=Widget.Box(
                vertical=True,
                child=[
                    self.volume_slider,
                    Widget.Box(
                        child=[
                            Widget.Icon(
                                image=self.audio.speaker.bind("icon_name"),
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
            anchor=["right"],
            namespace="ignis_volume",
            child=Widget.Box(child=[revealer]),
            revealer=revealer,
        )

    def start_volume(self):
        self.visible = True
        self.end_volume()

    @debounce(1500)
    def end_volume(self):
        self.visible = False

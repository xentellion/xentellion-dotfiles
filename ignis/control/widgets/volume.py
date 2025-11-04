from ignis.widgets import Widget, Box
from ignis.utils import Utils
from ignis.services.audio import AudioService


class VolumeWidget(Box):
    def __init__(self, BASH_COMMANDS: dict):
        self.audio = AudioService.get_default()
        super().__init__(
            child=[
                Widget.Button(
                    child=Widget.Icon(
                        image=self.audio.speaker.bind("icon_name"),
                    ),
                    css_classes=["battery"],
                    on_click=lambda self: Utils.exec_sh(BASH_COMMANDS["mute"]),
                ),
                Widget.Scale(
                    vertical=False,
                    min=0,
                    max=100,
                    step=1,
                    value=self.audio.speaker.bind("volume"),
                    on_change=lambda x: self.audio.speaker.set_volume(x.value),
                    css_classes=["control-metric"],
                    hexpand=True,
                ),
            ],
        )

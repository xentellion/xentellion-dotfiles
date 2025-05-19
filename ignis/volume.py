import asyncio
from ignis.widgets import Widget
from ignis.services.audio import AudioService
from ignis.utils import debounce


class Volume:
    def __init__(self):
        self.audio = AudioService.get_default()

        self.volume_icon = self.speaker_volume()
        self.volume_slider = self.speaker_slider()
        self.volume_revealer = self.right()

    def speaker_volume(self) -> Widget.Box:
        return Widget.Box(
            child=[
                Widget.Icon(
                    image=self.audio.speaker.bind("icon_name"),
                )
            ],
            css_classes=["volume-icon"],
        )

    def speaker_slider(self):
        return Widget.Scale(
            vertical=True,
            min=-27,
            max=125,
            step=1,
            value=self.audio.speaker.bind("volume"),
            css_classes=["metric"],
        )

    def right(self):
        return Widget.Revealer(
            child=Widget.Box(
                vertical=True,
                child=[
                    self.volume_slider,
                    self.volume_icon,
                ],
                css_classes=["volume"],
            ),
            transition_type="crossfade",
            transition_duration=200,
            reveal_child=False,
        )

    def create_window(self, monitor_id: int = 0) -> Widget.Window:
        return Widget.Window(
            namespace=f"ignis_volume_{monitor_id}",
            monitor=monitor_id,
            anchor=["right"],
            child=self.volume_revealer,
        )

    def start_volume(self):
        self.volume_revealer.reveal_child = True
        self.end_volume()

    @debounce(1500)
    def end_volume(self):
        self.volume_revealer.reveal_child = False

import asyncio
from ignis.widgets import Widget, Box
from ignis.services.mpris import MprisService, MprisPlayer

# from ignis.utils import Timeout


MPRIS = MprisService.get_default()


class Player(Box):
    def __init__(self, player: MprisPlayer):
        self._mpris_player = player
        self._mpris_player.connect("closed", lambda x: self.destroy())
        self._mpris_player.connect("notify::art-url", lambda x, y: self.load_art())

        self.player_button = Widget.Button(
            child=Widget.Label(
                label=player.bind(
                    "playback_status",
                    lambda value: ("󰏤" if value == "Playing" else "󰼛"),
                )
            ),
            on_click=lambda x: asyncio.create_task(player.play_pause_async()),
            visible=player.bind("can_play"),
        )

        # self.load_art()
        self.scale = Widget.Scale(
            min=0,
            max=self._mpris_player.bind("length"),
            value=self._mpris_player.bind("position"),
            hexpand=True,
            css_classes=["control-metric"],
            on_change=lambda x: asyncio.create_task(
                self._mpris_player.set_position_async(x.value)
            ),
            visible=self._mpris_player.bind("position", lambda value: value != -1),
        )

        super().__init__(
            child=[
                Widget.Label(
                    ellipsize="end",
                    label=player.bind("title"),
                    max_width_chars=30,
                    css_classes=["player_text"]
                ),
                Widget.Box(
                    child=[
                        self.scale,
                        Widget.Box(
                            child=[
                                Widget.Button(
                                    child=Widget.Label(label="󰼥"),
                                    on_click=lambda x: asyncio.create_task(
                                        player.previous_async()
                                    ),
                                    visible=player.bind("can_go_previous"),
                                ),
                                self.player_button,
                                Widget.Button(
                                    child=Widget.Label(label="󰼦"),
                                    on_click=lambda x: asyncio.create_task(
                                        player.next_async()
                                    ),
                                    visible=player.bind("can_go_next"),
                                ),
                            ],
                            css_classes=["player_controls"],
                            spacing=5,
                        ),
                    ],
                    valign="end",
                    halign="fill",
                    hexpand=True,
                    vexpand=True,
                ),
            ],
            css_classes=["controller", "player_background"],
            style=f'background-image: url("file://{self._mpris_player.art_url}");',
            vertical=True,
            visible=True,
            valign="end",
        )

    def load_art(self):
        try:
            self.style = (
                f'background-image: url("file://{self._mpris_player.art_url}");'
            )
        except TypeError as e:
            print(e)
            self.style = "background-image: none;"
            return

    def destroy(self):
        self.set_visible = False
        super().unparent()
        # self.set_reveal_child(False)
        # Timeout(self.transition_duration, super().unparent)


class Media(Box):
    def __init__(self):
        super().__init__(
            vertical=True,
            setup=lambda self: MPRIS.connect(
                "player_added", lambda x, player: self.__add_player(player)
            ),
        )

    def __add_player(self, obj: MprisPlayer) -> None:
        player = Player(obj)
        player.load_art()
        self.append(player)
        # player.set_reveal_child(True)

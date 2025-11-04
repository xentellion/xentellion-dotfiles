import asyncio
from ignis.widgets import Widget, Box
from ignis.services.mpris import MprisService, MprisPlayer

# from ignis.utils import Timeout


MPRIS = MprisService.get_default()


class Player(Box):
    def __init__(self, player: MprisPlayer):
        self._player = player
        # self._colors_path = f"{MEDIA_SCSS_CACHE_DIR}/{self.clean_desktop_entry()}.scss"
        player.connect("closed", lambda x: self.destroy())
        player.connect("notify::art-url", lambda x, y: self.load_art())

        self.player_button = Widget.Button(
            child=Widget.Icon(
                image=player.bind(
                    "playback_status",
                    lambda value: (
                        "media-playback-pause-symbolic"
                        if value == "Playing"
                        else "media-playback-start-symbolic"
                    ),
                ),
                pixel_size=18,
            ),
            on_click=lambda x: asyncio.create_task(player.play_pause_async()),
            visible=player.bind("can_play"),
            css_classes=["battery", "bluetooth"],
        )

        self.scale = Widget.Scale(
            value=player.bind("position"),
            max=player.bind("length"),
            hexpand=True,
            css_classes=["control-metric"],
            on_change=lambda x: asyncio.create_task(player.set_position_async(x.value)),
            visible=player.bind("position", lambda value: value != -1),
        )

        self.load_art()

        super().__init__(
            child=[
                Widget.Label(
                    ellipsize="end",
                    label=player.bind("title"),
                    style="color: white;",
                    max_width_chars=30,
                ),
                self.scale,
                Widget.Box(
                    child=[
                        Widget.Button(
                            child=Widget.Icon(
                                image="media-skip-backward-symbolic",
                                pixel_size=20,
                            ),
                            css_classes=["battery", "bluetooth"],
                            on_click=lambda x: asyncio.create_task(
                                player.previous_async()
                            ),
                            visible=player.bind("can_go_previous"),
                        ),
                        self.player_button,
                        Widget.Button(
                            child=Widget.Icon(
                                image="media-skip-forward-symbolic",
                                pixel_size=20,
                            ),
                            css_classes=["battery", "bluetooth"],
                            on_click=lambda x: asyncio.create_task(player.next_async()),
                            visible=player.bind("can_go_next"),
                        ),
                    ],
                    halign="center",
                    hexpand=True,
                    vexpand=True,
                    valign="end",
                ),
            ],
            css_classes=["controller", "player_background"],
            style=f'background-image: url("{self._player.art_url}");',
            vertical=True,
            visible=True,
            # height_request=188,
            valign="end",
        )
        # self.load_art()

    def load_art(self):
        if not self._player.art_url:
            self.style = "background-image: none;"
        try:
            self.style = f'background-image: url("{self._player.art_url}");'
        except TypeError:
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
        self.append(player)
        # player.set_reveal_child(True)

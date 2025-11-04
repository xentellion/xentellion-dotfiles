from ignis.widgets import Widget
from ignis.services.mpris import MprisService
from ignis.app import IgnisApp
from ignis.utils import Utils

from .widgets.battery import BatteryWidget
from .widgets.volume import VolumeWidget
from .widgets.backlight import BacklightWidget
from .widgets.network import NetworkWidget
from .widgets.vpn_updates import UpdateRevealer, VpnAirplaneWidget

import json

try:
    with open(
        ".config/ignis/scripts/control_scripts.json",
        "r",
        encoding="UTF-8",
    ) as f:
        BASH_COMMANDS = json.load(f)
except FileNotFoundError as e:
    print(e)
    BASH_COMMANDS = {}

APP = IgnisApp.get_default()


class Controller(Widget.RevealerWindow):
    def __init__(self, BASH_COMMANDS: dict):

        self.update_check = Utils.Poll(
            timeout=60 * 1000,
            callback=lambda x: Utils.exec_sh(BASH_COMMANDS["update"][1]),
        )
        # Сервисы
        self.mpris = MprisService.get_default()

        # Блоки
        self.player_button = Widget.Button(
            child=Widget.Label(label="󰏤"),
            css_classes=["battery", "bluetooth"],
        )

        self.player_box = Widget.Box(
            child=[
                Widget.Label(
                    label=(
                        "Some_text"
                        if len(self.mpris.players) == 0
                        else self.mpris.players[0].art_url
                    ),
                    # label=self.player.art_url,
                    style="color: white;",
                ),
                Widget.Button(
                    child=Widget.Label(
                        label="󱥠",
                        # style=f"color: #061840{"80" if self.dpi else "FF"};",
                    ),
                    css_classes=["battery", "bluetooth"],
                    hexpand=True,
                ),
                Widget.Box(
                    child=[
                        Widget.Scale(
                            vertical=False,
                            min=0,
                            max=100,
                            step=1,
                            css_classes=["control-metric"],
                            hexpand=True,
                        ),
                        Widget.Label(
                            label="00:00",
                            style="color: white;",
                        ),
                    ]
                ),
                Widget.Box(
                    child=[
                        Widget.Button(
                            child=Widget.Label(label="󰑟"),
                            css_classes=["battery", "bluetooth"],
                        ),
                        self.player_button,
                        Widget.Button(
                            child=Widget.Label(label="󰈑"),
                            css_classes=["battery", "bluetooth"],
                        ),
                    ],
                    halign="center",
                    hexpand=True,
                ),
            ],
            css_classes=["controller"],
            vertical=True,
            visible=False,
        )

        self.mpris.connect(
            "player_added", lambda x, player: self.player_control(player)
        )

        self.update_reveal_widget = UpdateRevealer(BASH_COMMANDS, self.update_check)

        revealer = Widget.Revealer(
            transition_type="slide_left",
            child=Widget.Box(
                child=[
                    Widget.Box(
                        child=[
                            BatteryWidget(BASH_COMMANDS),
                            VolumeWidget(BASH_COMMANDS),
                            BacklightWidget(BASH_COMMANDS),
                            NetworkWidget(BASH_COMMANDS),
                            VpnAirplaneWidget(
                                BASH_COMMANDS,
                                self.update_reveal_widget,
                                self.update_check,
                            ),
                            self.update_reveal_widget,
                        ],
                        css_classes=["controller"],
                        vertical=True,
                    ),
                    self.player_box,
                ],
                vertical=True,
            ),
            transition_duration=300,
            reveal_child=True,
        )

        super().__init__(
            visible=False,
            popup=True,
            layer="top",
            anchor=["top", "right", "bottom", "left"],
            namespace="revealer-controller",
            child=Widget.Box(
                child=[
                    Widget.Button(
                        vexpand=True,
                        hexpand=True,
                        css_classes=["unset"],
                        can_focus=False,
                        on_click=lambda x: self.hide_window(),
                    ),
                    revealer,
                ]
            ),
            revealer=revealer,
            style="min-height: 1000px;",
        )

    def hide_window(self):
        APP.toggle_window("revealer-controller")

    def player_control(self, player):
        self.player_box.visible = player is not None
        self.player = player
        self.player.connect("closed", lambda x: self.player_disconnect())

    def player_disconnect(self):
        self.player_box.visible = False
        print("disconnected")

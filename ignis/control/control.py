from ignis.widgets import Widget
from ignis.app import IgnisApp
from ignis.utils import Utils, Timeout

from .widgets.battery import BatteryWidget
from .widgets.volume import VolumeWidget
from .widgets.backlight import BacklightWidget
from .widgets.network import NetworkWidget
from .widgets.vpn_updates import UpdateRevealer, VpnAirplaneWidget
from .widgets.media import Media

# from .widgets.notifications import Notifications

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

        # Блоки
        self.update_reveal_widget = UpdateRevealer(BASH_COMMANDS, self.update_check)
        self.vpn_airplane = VpnAirplaneWidget(
            BASH_COMMANDS,
            self.update_reveal_widget,
            self.update_check,
        )
        self.player_box = Media()
        # self.notifications = Notifications()
        self.nw = NetworkWidget(BASH_COMMANDS)
        # self.nw.no_connection_box.visible = self.nw.bind_many(
        #     ["wifi_stat", "eth_stat"], lambda x, y: print(x, y)
        # )

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
                            self.vpn_airplane,
                            self.update_reveal_widget,
                        ],
                        css_classes=["controller"],
                        vertical=True,
                    ),
                    self.player_box,
                    # self.notifications,
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
        if self.vpn_airplane.update_window.visible:
            Timeout(self.revealer.transition_duration, self.vpn_airplane.update_toggle)

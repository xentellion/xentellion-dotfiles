from ignis.widgets import Widget, Box
from ignis.utils import Utils
from ignis.services.network import NetworkService


class NetworkWidget(Box):
    def __init__(self, BASH_COMMANDS: dict):
        self.network = NetworkService.get_default()
        self.bluetooth = (
            Utils.exec_sh(BASH_COMMANDS["bluetooth"][0]).stdout.strip() == "yes"
        )
        super().__init__(
            child=[
                Widget.Button(
                    child=Widget.Box(
                        child=[
                            Widget.Box(
                                child=[
                                    Widget.Label(
                                        label="󱎘",
                                        style="font-size: 200%;",
                                    ),
                                    Widget.Label(
                                        label="No connection",
                                        hexpand=True,
                                    ),
                                ],
                                hexpand=True,
                                spacing=10,
                                visible=self.network.wifi.bind(
                                    "is_connected",
                                    lambda x: not (
                                        x or self.network.ethernet.is_connected
                                    ),
                                ),
                            ),
                            Widget.Box(
                                child=[
                                    Widget.Icon(
                                        image=self.network.wifi.bind("icon_name"),
                                        pixel_size=25,
                                    ),
                                    Widget.Box(
                                        hexpand=True,
                                    ),
                                    Widget.Box(
                                        child=[
                                            Widget.Label(
                                                label="Wi-Fi",
                                            ),
                                            Widget.Label(
                                                label=self.network.wifi.devices[
                                                    0
                                                ].ap.bind_many(
                                                    ["is_connected"],
                                                    lambda x: self.set_network(),
                                                ),
                                                style="font-size: 75%; margin-top:5px;",
                                            ),
                                        ],
                                        vertical=True,
                                    ),
                                    Widget.Box(
                                        hexpand=True,
                                    ),
                                ],
                                visible=self.network.wifi.bind("is_connected"),
                                hexpand=True,
                            ),
                            Widget.Box(
                                child=[
                                    Widget.Icon(
                                        image=self.network.ethernet.bind("icon_name"),
                                        pixel_size=25,
                                    ),
                                    Widget.Box(
                                        hexpand=True,
                                    ),
                                    Widget.Box(
                                        child=[
                                            Widget.Label(
                                                label="Ethernet",
                                            ),
                                            # Widget.Label(
                                            #     label=self.network.ethernet.devices[
                                            #         0
                                            #     ].bind(
                                            #         "speed"
                                            #         # lambda x: self.set_network(),
                                            #     ),
                                            #     style="font-size: 75%; margin-top:5px;",
                                            # ),
                                        ],
                                        vertical=True,
                                    ),
                                    Widget.Box(
                                        hexpand=True,
                                    ),
                                ],
                                hexpand=True,
                                visible=self.network.ethernet.bind("is_connected"),
                            ),
                        ],
                        hexpand=True,
                        halign="fill",
                    ),
                    on_click=lambda x: Utils.exec_sh(BASH_COMMANDS["network"]),
                    css_classes=["big-button"],
                    hexpand=True,
                ),
                Widget.Button(
                    child=Widget.Label(
                        label="󰂯",
                    ),
                    on_click=lambda x: self.open_bluetooth_setup(BASH_COMMANDS),
                    css_classes=["battery", "bluetooth"],
                    style="font-size: 25px;",
                ),
            ],
        )

    def close_on_select(func):
        def inner(self):
            func(self)
            self.visible = False

        return inner

    @close_on_select
    def open_bluetooth_setup(self, BASH_COMMANDS):
        Utils.exec_sh(BASH_COMMANDS["bluetooth"][1])

    def set_bluetooth_label(self):
        result = Utils.exec_sh(
            "bluetoothctl show | grep Powered | sed -e 's/\tPowered://'"
        ).stdout.strip()
        return "󰂲" if result == "no" else "󰂯"

    def set_network(self):
        return self.network.wifi.devices[0].ap.ssid

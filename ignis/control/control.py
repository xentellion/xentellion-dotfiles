from ignis.widgets import Widget
from ignis.utils import Utils
from ignis.services.audio import AudioService
from ignis.services.backlight import BacklightService
from ignis.services.upower import UPowerService
from ignis.services.network import NetworkService
from ignis.services.mpris import MprisService


bash_commands = {
    "lock": "hyprlock",
    "shutdown": "shutdown now",
    "mute": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    "network": "kitty nmtui connect",
    "bluetooth": (
        'bluetoothctl show | grep Powered | sed -e "s/\tPowered://"',
        "blueman-manager",
    ),
    "idle": "",
    "power": "",
    "tor": (
        "systemctl is-active tor",
        "pkexec --user root sh ~/.config/ignis/scripts/tor.sh",
    ),
    "dpi": (
        "systemctl is-active zapret",
        "pkexec --user root sh ~/.config/ignis/scripts/dpi.sh",
    ),
    "airplane_mode": (
        "nmcli networking",
        "sh ~/.config/ignis/scripts/airplane.sh",
    ),
    "update": ("pacman -Qu | wc -l", "pacman -Qu"),
}


class Controller(Widget.RevealerWindow):
    def __init__(self):
        # Контрлирующие переменные
        self.airplane = (
            Utils.exec_sh(bash_commands["airplane_mode"][0]).stdout.strip() == "enabled"
        )
        self.dpi = Utils.exec_sh(bash_commands["dpi"][0]).stdout.strip() == "inactive"
        self.tor = Utils.exec_sh(bash_commands["tor"][0]).stdout.strip() == "inactive"
        self.bluetooth = (
            Utils.exec_sh(bash_commands["bluetooth"][0]).stdout.strip() == "yes"
        )
        # Обновление по расписанию
        self.update_check = Utils.Poll(
            timeout=10 * 60 * 1000,
            callback=lambda x: Utils.exec_sh(bash_commands["update"][0]),
        )

        # Сервисы
        self.audio = AudioService.get_default()
        self.backlight = BacklightService.get_default()
        self.power = UPowerService.get_default()
        self.network = NetworkService.get_default()
        self.mpris = MprisService.get_default()

        self.mpris.connect(
            "player_added", lambda x, player: self.player_control(player)
        )

        # Блоки
        self.battery_widget = self.create_battery_box()
        self.volume_widget = self.create_volume_box()
        self.backligh_widget = self.create_backlight_box()
        self.wifi_bluetooth_widget = self.create_wifi_bluetooth_box()
        self.update_reveal_widget = self.create_update_box()
        self.vpn_airplane_widget = self.create_vpn_airplane_box()

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
                        style=f"color: #061840{"80" if self.dpi else "FF"};",
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
                            # value=self.audio.speaker.bind("volume"),
                            # on_change=lambda x: self.audio.speaker.set_volume(x.value),
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

        revealer = Widget.Revealer(
            transition_type="slide_down",
            child=Widget.Box(
                child=[
                    Widget.Box(
                        child=[
                            self.battery_widget,
                            self.volume_widget,
                            self.backligh_widget,
                            self.wifi_bluetooth_widget,
                            self.vpn_airplane_widget,
                            self.update_reveal_widget,
                        ],
                        css_classes=["controller"],
                        vertical=True,
                    ),
                    self.player_box,
                ],
                vertical=True,
            ),
            transition_duration=1000,
            reveal_child=True,
        )

        super().__init__(
            visible=False,
            popup=True,
            layer="top",
            anchor=["top", "right"],
            namespace="revealer-controller",
            child=Widget.Box(child=[revealer]),
            revealer=revealer,
            style="min-height: 1000px;",
        )

    # --------------------------------------------------------------------

    def close_on_select(func):
        def inner(self):
            func(self)
            self.visible = False

        return inner

    # --------------------------------------------------------------------

    def get_battery_power(self, time_remaining, charging, charged):
        mins = time_remaining // 60 % 60
        hours = time_remaining // 60 // 60
        if charged or mins + hours == 0:
            return "Charged"
        else:
            if charging:
                return f"Charged in {f"{hours}h {mins}m" if hours > 0 else f"{mins}m"}"
            else:
                return f"Empty in {f"{hours}h {mins}m" if hours > 0 else f"{mins}m"}"

    def create_battery_box(self):
        return Widget.Box(
            child=[
                Widget.Button(
                    child=Widget.Box(
                        child=[
                            Widget.Icon(
                                image=self.power.display_device.bind("icon_name"),
                            ),
                            Widget.Label(
                                label=self.power.display_device.bind(
                                    "percent", lambda x: f" {x:.0f}% "
                                )
                            ),
                            Widget.Label(
                                label=self.power.display_device.bind_many(
                                    ["time_remaining", "charging", "charged"],
                                    lambda x, y, z: self.get_battery_power(x, y, z),
                                )
                            ),
                        ],
                    ),
                    css_classes=["battery", "battery-life", "disableHover"],
                ),
                Widget.Box(hexpand=True),
                Widget.Box(
                    child=[
                        Widget.Button(
                            child=Widget.Label(label="󰌾"),
                            css_classes=["battery"],
                            on_click=lambda self: Utils.exec_sh(bash_commands["lock"]),
                        ),
                        Widget.Button(
                            child=Widget.Label(label="󰐥"),
                            css_classes=["battery"],
                            on_click=lambda self: Utils.exec_sh(
                                bash_commands["shutdown"]
                            ),
                        ),
                    ]
                ),
            ],
            vertical=False,
            halign="fill",
        )

    def create_volume_box(self):
        return Widget.Box(
            child=[
                Widget.Button(
                    child=Widget.Icon(
                        image=self.audio.speaker.bind("icon_name"),
                    ),
                    css_classes=["battery"],
                    on_click=lambda self: Utils.exec_sh(bash_commands["mute"]),
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

    def create_backlight_box(self):
        return Widget.Box(
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
            ],
        )

    # --------------------------------------------------------------------

    def create_wifi_bluetooth_box(self):
        return Widget.Box(
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
                    on_click=lambda x: Utils.exec_sh(bash_commands["network"]),
                    css_classes=["big-button"],
                    hexpand=True,
                ),
                Widget.Button(
                    child=Widget.Label(
                        label="󰂯",
                    ),
                    on_click=lambda x: self.open_bluetooth_setup(),
                    css_classes=["battery", "bluetooth"],
                    style="font-size: 25px;",
                ),
            ],
        )

    @close_on_select
    def open_bluetooth_setup(self):
        Utils.exec_sh(bash_commands["bluetooth"][1])

    def set_bluetooth_label(self):
        result = Utils.exec_sh(
            "bluetoothctl show | grep Powered | sed -e 's/\tPowered://'"
        ).stdout.strip()
        return "󰂲" if result == "no" else "󰂯"

    def set_network(self):
        return self.network.wifi.devices[0].ap.ssid

    # --------------------------------------------------------------------

    def create_vpn_airplane_box(self):
        # Авиарежим
        self.airplane_button = Widget.Button(
            child=Widget.Label(
                label="󰀝",
                style=f"color: #061840{"80" if self.airplane else "FF"};",
            ),
            on_click=lambda x: self.airplane_toggle(),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )
        # Включить/отключить маршрутизацию через тор
        self.vpn_button = Widget.Button(
            child=Widget.Label(
                label="󰌆",
                style=f"color: #061840{"80" if self.tor else "FF"};",
            ),
            css_classes=["battery", "bluetooth"],
            on_click=lambda x: self.vpn_toggle(),
            hexpand=True,
        )
        # Включить/отключить средства обхода dpi
        self.dpi_button = Widget.Button(
            child=Widget.Label(
                label="󱥠",
                style=f"color: #061840{"80" if self.dpi else "FF"};",
            ),
            css_classes=["battery", "bluetooth"],
            on_click=lambda x: self.dpi_toggle(),
            hexpand=True,
        )
        # Включить/отключить засыпание экрана
        self.idle_button = Widget.Button(
            child=Widget.Label(
                label="󰈉",
            ),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )
        # Переключение между режимами батареи
        self.power_modes_button = Widget.Button(
            child=Widget.Label(
                label="󰌪",
            ),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )
        # Проверка обновлений
        self.updates = Widget.Button(
            child=Widget.Box(
                child=[
                    Widget.Label(
                        label="󰚰",
                        hexpand=True,
                    ),
                    Widget.Label(
                        label=self.update_check.bind(
                            "output", lambda x: x.stdout.strip()
                        ),
                        hexpand=True,
                    ),
                ],
                vertical=False,
            ),
            on_click=lambda x: self.update_toggle(),
            on_right_click=lambda x: Utils.exec_sh("kitty sudo pacman -Syu"),
            css_classes=["battery", "bluetooth"],
            halign="fill",
            hexpand=True,
        )
        # Финальный блок
        return Widget.Box(
            child=[
                Widget.Box(
                    child=[
                        # self.idle_button,
                        # self.power_modes_button,
                        self.updates,
                        self.vpn_button,
                        self.dpi_button,
                        self.airplane_button,
                    ],
                    hexpand=True,
                    halign="fill",
                )
            ],
        )

    def airplane_toggle(self):
        result = Utils.exec_sh(bash_commands["airplane_mode"][1]).stdout.strip()
        self.airplane_button.child.set_style(
            f"color: #061840{"FF" if result != "enabled" else "80"};"
        )

    def vpn_toggle(self):
        result = Utils.exec_sh(bash_commands["tor"][1]).stdout.split("\n")[-2]
        self.vpn_button.child.set_style(
            f"color: #061840{"FF" if result != "started" else "80"};"
        )

    def dpi_toggle(self):
        result = Utils.exec_sh(bash_commands["dpi"][1]).stdout.strip()
        self.dpi_button.child.set_style(
            f"color: #061840{"FF" if result != "active" else "80"};"
        )

    def update_toggle(self):
        self.update_reveal_widget.visible = not self.update_reveal_widget.visible

    def idle_toggle(self):
        pass

    def power_toggle(self):
        pass

    # --------------------------------------------------------------------

    def create_update_box(self):
        return Widget.Revealer(
            transition_type="slide_down",
            child=Widget.Scroll(
                child=Widget.Box(
                    vertical=True,
                    child=self.update_check.bind(
                        "output", lambda x: self.get_updates_list()
                    ),
                    halign="start",
                    spacing=5,
                )
            ),
            transition_duration=300,
            reveal_child=True,
            visible=False,
            css_classes=["updater"],
            # style=f"min-height: "
        )

    def get_updates_list(self):
        data = [
            Widget.Label(label="->".join(x.split()[::3]), halign="start")
            for x in Utils.exec_sh(bash_commands["update"][1])
            .stdout.strip()
            .split("\n")
            if x
        ]
        if len(data) > 0:
            return data
        return [
            Widget.Label(label="No updates available", halign="start"),
        ]

    # --------------------------------------------------------------------

    def player_control(self, player):
        self.player_box.visible = player is not None
        self.player = player
        self.player.connect("closed", lambda x: self.player_disconnect())

    def player_disconnect(self):
        self.player_box.visible = False
        print("disconnected")

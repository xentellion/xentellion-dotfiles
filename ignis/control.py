from ignis.widgets import Widget
from ignis.utils import Utils
from ignis.services.audio import AudioService
from ignis.services.backlight import BacklightService
from ignis.services.upower import UPowerService
from ignis.services.network import NetworkService


bash_commands = {
    "lock": "hyprlock",
    "shutdown": "shutdown now",
    "mute": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    "network": "kitty nmtui connect",
    "bluetooth": "blueman-manager",
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
    "airplane_mode": ("nmcli networking", "sh ~/.config/ignis/scripts/airplane.sh"),
}


class Controller:
    def __init__(self):
        self.is_active = True

        self.airplane = (
            Utils.exec_sh(bash_commands["airplane_mode"][0]).stdout.strip() != "enabled"
        )
        self.dpi = Utils.exec_sh(bash_commands["dpi"][0]).stdout.strip() == "inactive"
        self.tor = Utils.exec_sh(bash_commands["tor"][0]).stdout.strip() == "inactive"

        self.audio = AudioService.get_default()
        self.backlight = BacklightService.get_default()
        self.power_button = UPowerService.get_default().display_device
        self.network = NetworkService.get_default().wifi

        self.box1 = self.battery_box()
        self.box2 = self.volume_box()
        self.box3 = self.backlight_box()
        self.box4 = self.wifi_bluetooth_box()
        self.box5 = self.vpn_airplane_box()

    def get_power(self, time):
        mins = time // 60 % 60
        hours = time // 60 // 60
        return f" {f"{hours}h {mins}m" if hours > 0 else f"{mins}m"} remain"

    def battery_box(self):
        # This is an abomination
        return Widget.Box(
            child=[
                Widget.Box(
                    child=[
                        Widget.Button(
                            child=Widget.Box(
                                child=[
                                    Widget.Icon(
                                        image=self.power_button.bind("icon_name"),
                                    ),
                                    Widget.Label(
                                        label=self.power_button.bind(
                                            "percent", lambda x: f" {x:.0f}%"
                                        )
                                    ),
                                    Widget.Label(
                                        label=self.power_button.bind(
                                            "time_remaining",
                                            lambda x: self.get_power(x),
                                        )
                                    ),
                                ],
                            ),
                            css_classes=["battery", "battery-life", "disableHover"],
                        )
                    ],
                    hexpand=True,
                ),
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

    def volume_box(self):
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

    def backlight_box(self):
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

    def wifi_bluetooth_box(self):
        return Widget.Box(
            child=[
                Widget.Button(
                    child=Widget.Box(
                        child=[
                            Widget.Icon(
                                image=self.network.bind("icon_name"),
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
                                        label=self.network.devices[0].ap.ssid,
                                        # label="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                                        style="font-size: 75%; margin-top:5px;",
                                    ),
                                ],
                                vertical=True,
                            ),
                            Widget.Box(
                                hexpand=True,
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
                        # Change label n BT being on/off
                        label=self.bluetooth_label()
                    ),
                    on_click=lambda self: Utils.exec_sh(bash_commands["bluetooth"]),
                    css_classes=["battery", "bluetooth"],
                    style="font-size: 25px;",
                ),
            ],
        )

    def bluetooth_label(self):
        result = Utils.exec_sh(
            "bluetoothctl show | grep Powered | sed -e 's/\tPowered://'"
        ).stdout.strip()
        return "󰂲" if result == "no" else "󰂯"

    def vpn_airplane_box(self):
        self.airplane_button = Widget.Button(
            child=Widget.Label(
                label="󰀝",
                style=f"color: #061840{"FF" if self.airplane else "80"};",
            ),
            on_click=lambda x: self.airplane_toggle(),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )
        self.vpn_button = Widget.Button(
            child=Widget.Label(
                label="󰌆",
                style=f"color: #061840{"80" if self.tor else "FF"};",
            ),
            css_classes=["battery", "bluetooth"],
            on_click=lambda x: self.vpn_toggle(),
            hexpand=True,
        )
        self.dpi_button = Widget.Button(
            child=Widget.Label(
                label="dpi",
                style=f"color: #061840{"80" if self.dpi else "FF"};",
            ),
            css_classes=["battery", "bluetooth"],
            on_click=lambda x: self.dpi_toggle(),
            hexpand=True,
        )
        self.idle_button = Widget.Button(
            child=Widget.Label(
                label="󰈉",
            ),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )
        self.power_button = Widget.Button(
            child=Widget.Label(
                label="󰌪",
            ),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )

        return Widget.Box(
            child=[
                Widget.Box(
                    child=[
                        self.idle_button,
                        self.power_button,
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
        result = (
            Utils.exec_sh(bash_commands["airplane_mode"][1]).stdout.strip() == "enabled"
        )
        self.airplane_button.child.set_style(
            f"color: #061840{"80" if result else "FF"};"
        )

    def vpn_toggle(self):
        result = Utils.exec_sh(bash_commands["tor"][1]).stdout.split("\n")[-2]
        self.vpn_button.child.set_style(
            f"color: #061840{"FF" if result != "started" else "80"};"
        )

    def dpi_toggle(self):
        result = Utils.exec_sh(bash_commands["dpi"][1]).stdout.strip()
        self.dpi_button.child.set_style(
            f"color: #061840{"80" if result != "inactive" else "FF"};"
        )

    def idle_toggle(self):
        pass

    def box(self):
        return Widget.Revealer(
            child=Widget.Box(
                child=[
                    self.box1,
                    self.box2,
                    self.box3,
                    self.box4,
                    self.box5,
                ],
                css_classes=["controller"],
                vertical=True,
            ),
            # transition_type="slide_left",
            transition_type="swing_up",
            transition_duration=10000,
            reveal_child=self.is_active,
        )

    def boxer(self):
        return Widget.Box(child=[self.box()])

    def create_window(self):
        # return Widget.Window(
        #     namespace="some-window",
        #     monitor=0,
        #     anchor=["top", "right"],
        #     layer="top",
        #     child=self.box(),
        # )

        return Widget.RevealerWindow(
            namespace="revealer-window",
            monitor=0,
            visible=True,
            popup=True,
            layer="top",
            anchor=["top", "right"],
            child=self.boxer(),  # do not set Widget.Revealer as a direct child!
            revealer=self.box(),
        )

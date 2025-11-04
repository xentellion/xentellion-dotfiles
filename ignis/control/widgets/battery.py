from ignis.widgets import Widget, Box
from ignis.utils import Utils
from ignis.services.upower import UPowerService


class BatteryWidget(Box):
    def __init__(self, BASH_COMMANDS: dict):
        self.power = UPowerService.get_default()
        super().__init__(
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
                            on_click=lambda self: Utils.exec_sh(BASH_COMMANDS["lock"]),
                        ),
                        Widget.Button(
                            child=Widget.Label(label="󰐥"),
                            css_classes=["battery"],
                            on_click=lambda self: Utils.exec_sh(
                                BASH_COMMANDS["shutdown"]
                            ),
                        ),
                    ]
                ),
            ],
            vertical=False,
            halign="fill",
        )

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

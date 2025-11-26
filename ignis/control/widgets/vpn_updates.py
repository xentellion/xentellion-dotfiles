from ignis.app import IgnisApp
from ignis.widgets import Widget, Box, Revealer
from ignis.utils import Utils, Poll


APP = IgnisApp.get_default()


class UpdateRevealer(Revealer):
    def __init__(self, BASH_COMMANDS: dict, update_check: Poll):
        self.update_check = update_check
        # Обновление по расписанию
        super().__init__(
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
        )

    def get_updates_list(self):
        data = [
            Widget.Label(label="->".join(x.split()[::3]), halign="start")
            for x in self.update_check.output.stdout.strip().split("\n")
            if x
        ]
        # return data
        if len(data) > 0:
            return data
        return [
            Widget.Label(label="No updates available", halign="start"),
        ]


class VpnAirplaneWidget(Box):
    def __init__(
        self, BASH_COMMANDS: dict, update_window: Revealer, update_check: Poll
    ):
        self.airplane = (
            Utils.exec_sh(BASH_COMMANDS["airplane_mode"][0]).stdout.strip() == "enabled"
        )
        self.tor = Utils.exec_sh(BASH_COMMANDS["tor"][0]).stdout.strip() == "inactive"
        self.update_check = update_check
        self.update_window = update_window
        # Авиарежим
        self.airplane_button = Widget.Button(
            child=Widget.Label(
                label="",
                style=f"color: #061840{"80" if self.airplane else "FF"};",
            ),
            on_click=lambda x: self.airplane_toggle(BASH_COMMANDS),
            css_classes=["battery", "bluetooth"],
            hexpand=True,
        )
        # Включить/отключить маршрутизацию через тор
        self.tor_button = Widget.Button(
            child=Widget.Label(
                label="",
                style=f"color: #061840{"80" if self.tor else "FF"};",
            ),
            css_classes=["battery", "bluetooth"],
            on_click=lambda x: self.vpn_toggle(BASH_COMMANDS),
            hexpand=True,
        )
        # Включить/отключить засыпание экрана
        self.vpn_button = Widget.Button(
            child=Widget.Label(
                label="󰌆",
            ),
            css_classes=["battery", "bluetooth"],
            on_click=lambda x: self.open_vpn(),
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
                            "output", lambda x: self.check_updates(x)
                        ),
                        hexpand=True,
                    ),
                ],
                vertical=False,
            ),
            on_click=lambda x: self.update_toggle(),
            on_right_click=lambda x: self.load_updates(),
            css_classes=["battery", "bluetooth"],
            halign="fill",
            hexpand=True,
        )
        # Финальный блок

        super().__init__(
            child=[
                Widget.Box(
                    child=[
                        # self.idle_button,
                        # self.power_modes_button,
                        self.updates,
                        self.tor_button,
                        self.vpn_button,
                        self.airplane_button,
                    ],
                    hexpand=True,
                    halign="fill",
                )
            ],
        )

    def check_updates(self, checkupdate_process):
        if not checkupdate_process.stdout:
            return "0"
        return str(len(checkupdate_process.stdout.strip().split("\n")))

    def update_toggle(self):
        self.update_window.visible = not self.update_window.visible

    @Utils.run_in_thread
    def open_vpn(self):
        APP.close_window("revealer-controller")
        Utils.exec_sh("/opt/v2rayn-bin/v2rayN")

    @Utils.run_in_thread
    def load_updates(self):
        APP.close_window("revealer-controller")
        Utils.exec_sh("kitty sudo pacman -Syu")

    @Utils.run_in_thread
    def airplane_toggle(self, BASH_COMMANDS: dict):
        result = Utils.exec_sh(BASH_COMMANDS["airplane_mode"][1]).stdout.strip()
        self.airplane_button.child.set_style(
            f"color: #061840{"FF" if result != "enabled" else "80"};"
        )

    @Utils.run_in_thread
    def vpn_toggle(self, BASH_COMMANDS: dict):
        result = Utils.exec_sh(BASH_COMMANDS["tor"][1]).stdout.split("\n")[-2]
        self.tor_button.child.set_style(
            f"color: #061840{"FF" if result != "started" else "80"};"
        )

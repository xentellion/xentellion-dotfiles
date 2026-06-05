pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

import "../config"

Singleton {
    id: root

    readonly property int warningLevel: 30
    readonly property int dangerLevel: 15

    readonly property string timeLongTemplate: " in %1 h %2 min"
    readonly property string timeShortTemplate: " in %1 min"

    readonly property var battery: UPower.displayDevice

    readonly property string timeToEmpty: "Empty" + getTimeUntil(battery?.timeToEmpty)
    readonly property string timeToFull: "Full" + getTimeUntil(battery?.timeToFull)
    readonly property string batteryTemplate: "Battery level is at %1%!"

    readonly property var assets: {
        "warning": Qt.resolvedUrl("../assets/icons/warning.png"),
        "danger": Qt.resolvedUrl("../assets/icons/danger.png")
    }

    property real percentage: Math.floor(battery?.percentage * 100)
    property bool isCharging: !UPower.onBattery
    property bool isLaptop: battery?.isLaptopBattery

    property bool isWarningSent: false
    property bool isDangerSent: false

    property int alertState: {
        // 0 - (dis)charging
        // 1 - warning
        // 2 = danger
        if (isCharging)
            return 0;
        else if (percentage <= dangerLevel)
            return 2;
        else if (percentage <= warningLevel)
            return 1;
        return 0;
    }

    function getTimeUntil(timeInSeconds) {
        let hours = Math.floor(timeInSeconds / 3600);
        let minutes = Math.floor(timeInSeconds % 3600 / 60);
        return hours > 0 ? timeLongTemplate.arg(hours).arg(minutes) : timeShortTemplate.arg(minutes);
    }

    readonly property string icon: {
        if (!battery.ready) {
            return Data.batteryEmpty;
        }
        // Hell yeah, independent form magical amount of icons in array
        let icon = Data.batteryLevel[Math.min(Math.floor(percentage / Data.batteryLevel.length), Data.batteryLevel.length - 1)];
        let connection = null;
        switch (battery?.state) {
        case 1:
            connection = Data.chargingIcon;
            break;
        case 4:
            connection = `<font color="${Theme.warning}">${Data.chargingIcon}</font>`;
            break;
        case 5:
            connection = Data.pluggedIcon;
            break;
        case 6:
            connection = Data.pluggedIcon;
            break;
        default:
            connection = "";
            break;
        }
        connection += " ";
        return (icon !== undefined ? icon : Data.batteryEmpty) + connection + percentage + "%";
    }

    onPercentageChanged: {
        if (!battery?.ready)
            return;
        checkBatteryState();
    }

    onIsChargingChanged: {
        if (!battery?.ready)
            return;
        if (isCharging) {
            isDangerSent = false;
            isWarningSent = false;
            BrightnessService.restoreScreen.running = true;
        } else {
            checkBatteryState();
        }
    }

    function checkBatteryState() {
        switch (alertState) {
        case 1:
            if (isWarningSent)
                break;
            warningSend.running = true;
            isWarningSent = true;
            console.log("WARNING");
            break;
        case 2:
            if (isDangerSent)
                break;
            dangerSend.running = true;
            isDangerSent = true;
            isWarningSent = true;
            console.log("DANGER");
            BrightnessService.dimScreen.running = true;
            break;
        default:
            if (isDangerSent || isWarningSent) {
                isDangerSent = false;
                isWarningSent = false;
            }
        }
    }

    readonly property var shutdown: Process {
        command: ["shutdown", "now"]
    }

    readonly property var reboot: Process {
        command: ["reboot"]
    }

    Process {
        id: warningSend
        command: ["notify-send", "-u", "critical", "-i", root.assets["warning"], "Battery low", root.batteryTemplate.arg(root.percentage)]
    }

    Process {
        id: dangerSend
        command: ["notify-send", "-u", "critical", "-i", root.assets["danger"], "Battery is CRITICALLY low!", root.batteryTemplate.arg(root.percentage)]
    }
}

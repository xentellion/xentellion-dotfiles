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

    readonly property string timeToEmpty: "Empty" + getTimeUntil(UPower.displayDevice?.timeToEmpty)
    readonly property string timeToFull: "Full" + getTimeUntil(UPower.displayDevice?.timeToFull)

    readonly property string batteryTemplate: "Battery level is at %1%!"
    readonly property var batteryLevel: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹", "󰁹"]
    readonly property string batteryEmpty: "󰂎"
    readonly property string pluggedIcon: ""
    readonly property string chargingIcon: "󱐋"

    readonly property var assets: {
        "warning": Qt.resolvedUrl("../../../assets/icons/warning.png"),
        "danger": Qt.resolvedUrl("../../../assets/icons/danger.png")
    }

    property real percentage: Math.floor(UPower.displayDevice?.percentage * 100)
    property bool isCharging: !UPower.onBattery
    property bool isLaptop: UPower.displayDevice?.isLaptopBattery

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
        if (!UPower.displayDevice.ready) {
            return batteryEmpty;
        }
        console.log("Request");
        let icon = batteryLevel[Math.floor(percentage / 10)];
        let connection = null;
        console.log(UPower.displayDevice?.state);
        switch (UPower.displayDevice?.state) {
        case 1:
            connection = chargingIcon;
            break;
        case 4:
            connection = `<font color="${Theme.warning}">${chargingIcon}</font>`;
            break;
        case 5:
            connection = pluggedIcon;
            break;
        case 6:
            connection = pluggedIcon;
            break;
        default:
            connection = "";
            break;
        }
        connection += " ";
        return (icon !== undefined ? icon : batteryEmpty) + connection + percentage + "%";
    }

    onPercentageChanged: {
        if (!UPower.displayDevice?.ready)
            return;
        checkBatteryState();
    }

    onIsChargingChanged: {
        if (!UPower.displayDevice?.ready)
            return;
        if (isCharging) {
            isDangerSent = false;
            isWarningSent = false;
            restoreScreen.running = true;
        } else {
            checkBatteryState();
        }
    }

    function checkBatteryState() {
        switch (checkState()) {
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
            dimScreen.running = true;
            break;
        default:
            if (isDangerSent || isWarningSent) {
                isDangerSent = false;
                isWarningSent = false;
            }
        }
    }

    function checkState() {
        if (isCharging)
            return 0;
        else if (percentage <= dangerLevel)
            return 2;
        else if (percentage <= warningLevel)
            return 1;
        return 0;
    }

    Process {
        id: warningSend
        command: ["notify-send", "-u", "critical", "-i", root.assets["warning"], "Battery low", root.batteryTemplate.arg(root.percentage)]
    }

    Process {
        id: dangerSend
        command: ["notify-send", "-u", "critical", "-i", root.assets["danger"], "Battery is CRITICALLY low!", root.batteryTemplate.arg(root.percentage)]
    }

    Process {
        id: dimScreen
        command: ["brightnessctl", "--save", "set", "10%"]
    }

    Process {
        id: restoreScreen
        command: ["brightnessctl", "--restore"]
    }
}

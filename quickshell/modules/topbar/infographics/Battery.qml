import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.UPower

import "../../data"
import "../../effects"
import "../../notifications"
import "../defaultCells"

DefaultCell {
    id: battery
    required property int spacing

    readonly property int warningLevel: 30
    readonly property int dangerLevel: 15
    readonly property int blinkEasing: Easing.InOutSine
    readonly property int blinkWarningDuration: 1000
    readonly property int blinkDangerDuration: 500

    property real percentage: Math.floor(UPower.displayDevice?.percentage * 100)
    property bool isCharging: !UPower.onBattery
    property string chargingState: "Unknown"

    property string batteryTemplate: "Battery level is at %1%!"
    property var batteryLevel: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹", "󰁹"]
    property string batteryEmpty: "󰂎"
    property var assets: {
        "warning": Qt.resolvedUrl("../../../assets/icons/warning.png"),
        "danger": Qt.resolvedUrl("../../../assets/icons/danger.png")
    }

    property bool forceCheck: false
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

    property bool isWarningSent: false
    property bool isDangerSent: false

    state: ""

    Layout.preferredWidth: childrenRect.width + spacing * 4
    visible: UPower.displayDevice?.isLaptopBattery

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

    LabelWhite {
        id: label
        canHover: false
        anchors.centerIn: parent

        text: {
            if (!UPower.displayDevice.ready) {
                return battery.batteryEmpty;
            }
            let icon = battery.batteryLevel[Math.floor(battery.percentage / 10)];
            return (icon !== undefined ? icon : battery.batteryEmpty) + (battery.isCharging ? "󱐋 " : " ") + battery.percentage + "%";
        }
    }

    Process {
        id: warningSend
        command: ["notify-send", "-u", "critical", "-i", battery.assets["warning"], "Battery low", battery.batteryTemplate.arg(battery.percentage)]
    }

    Process {
        id: dangerSend
        command: ["notify-send", "-u", "critical", "-i", battery.assets["danger"], "Battery is CRITICALLY low!", battery.batteryTemplate.arg(battery.percentage)]
    }

    Process {
        id: dimScreen
        command: ["brightnessctl", "--save", "set", "10%"]
    }

    Process {
        id: restoreScreen
        command: ["brightnessctl", "--restore"]
    }

    states: [
        State {
            name: "danger"
            when: battery.alertState === 2
            PropertyChanges {
                battery {
                    color: Theme.urgent
                    border.color: Theme.white
                }
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "danger"
            animations: dangerBlinkAnimation
            reversible: true
        }
    ]

    SequentialAnimation {
        id: dangerBlinkAnimation
        loops: Animation.Infinite
        ParallelAnimation {
            ColorAnimation {
                target: battery
                duration: battery.blinkDangerDuration
                easing: battery.blinkEasing
            }
            ColorAnimation {
                target: battery.border
                duration: battery.blinkDangerDuration
                easing: battery.blinkEasing
            }
        }
        ParallelAnimation {
            ColorAnimation {
                target: battery
                to: Theme.cellColor
                duration: battery.blinkDangerDuration
                easing: battery.blinkEasing
            }
            ColorAnimation {
                target: battery.border
                to: Theme.cellBorder
                duration: battery.blinkDangerDuration
                easing: battery.blinkEasing
            }
        }
    }
}

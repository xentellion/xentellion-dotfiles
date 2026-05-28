import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../../data"
import "../../effects"
import "../defaultCells"

DefaultCell {
    id: battery
    required property int spacing
    readonly property int warningLevel: 30
    readonly property int dangerLevel: 15

    readonly property int blinkWarningDuration: 1000
    readonly property int blinkDangerDuration: 500

    Layout.preferredWidth: childrenRect.width + spacing * 4

    property real percentage: Math.floor(UPower.displayDevice.percentage * 100)
    property bool isCharging: !UPower.onBattery
    property string chargingState: "Unknown"

    LabelWhite {
        id: label
        canHover: false
        anchors.centerIn: parent
        text: {
            let icon = null;
            switch (Math.floor(battery.percentage / 10)) {
            case 0:
                icon = "󰁺";
                break;
            case 1:
                icon = "󰁻";
                break;
            case 2:
                icon = "󰁼";
                break;
            case 3:
                icon = "󰁽";
                break;
            case 4:
                icon = "󰁾";
                break;
            case 5:
                icon = "󰁿";
                break;
            case 6:
                icon = "󰂀";
                break;
            case 7:
                icon = "󰂁";
                break;
            case 8:
                icon = "󰂂";
                break;
            default:
                icon = "󰁹";
                break;
            }
            return (icon !== null ? icon : "󰂎") + (battery.isCharging ? "󱐋 " : " ") + battery.percentage + "%";
        }

        states: [
            State {
                name: "danger"
                when: (battery.percentage < battery.dangerLevel && battery.isCharging == false)
                PropertyChanges {
                    battery {
                        color: Theme.urgent
                        border.color: Theme.white
                    }
                }
            },
            State {
                name: "warning"
                when: (battery.percentage < battery.warningLevel && battery.isCharging == false)
                PropertyChanges {
                    battery {
                        color: Theme.warning
                        border.color: Theme.textColor
                    }
                    label {
                        color: Theme.textColor
                    }
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "warning"
                reversible: true
                SequentialAnimation {
                    loops: Animation.Infinite
                    ColorAnimation {
                        duration: battery.blinkWarningDuration
                        easing.type: Easing.InOutCubic
                    }
                    ParallelAnimation {
                        ColorAnimation {
                            target: battery
                            duration: battery.blinkWarningDuration
                            to: Theme.cellColor
                            easing.type: Easing.InOutCubic
                        }
                        ColorAnimation {
                            target: battery.border
                            duration: battery.blinkWarningDuration
                            to: Theme.cellBorder
                            easing.type: Easing.InOutCubic
                        }
                        ColorAnimation {
                            target: label
                            duration: battery.blinkWarningDuration
                            to: Theme.white
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            },
            Transition {
                from: "*"
                to: "danger"
                reversible: true
                SequentialAnimation {
                    loops: Animation.Infinite
                    ColorAnimation {
                        duration: battery.blinkDangerDuration
                        easing.type: Easing.InOutCubic
                    }
                    ParallelAnimation {
                        ColorAnimation {
                            duration: battery.blinkDangerDuration
                            to: Theme.cellColor
                            easing.type: Easing.InOutCubic
                        }
                        ColorAnimation {
                            target: battery.border
                            duration: battery.blinkDangerDuration
                            to: Theme.cellBorder
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            }
        ]
    }
}

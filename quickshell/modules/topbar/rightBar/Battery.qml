import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../components"
import "../../../services"

DefaultCell {
    id: battery
    required property int spacing

    readonly property int blinkEasing: Easing.InOutSine
    readonly property int blinkWarningDuration: 1000
    readonly property int blinkDangerDuration: 500

    Layout.preferredWidth: childrenRect.width + spacing * 4
    visible: BatteryService.isLaptop

    LabelWhite {
        id: label
        anchors.centerIn: parent

        canHover: false
        isClickable: false

        text: BatteryService.icon
    }

    states: [
        State {
            name: "danger"
            when: BatteryService.alertState === 2
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

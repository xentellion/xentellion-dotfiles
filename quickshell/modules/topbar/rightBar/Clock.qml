import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../components"
import "../../../services"

DefaultCell {
    id: timePlate
    required property int spacing

    Layout.preferredWidth: labelLayout.width + spacing * 4

    RowLayout {
        id: labelLayout
        anchors.centerIn: timePlate
        spacing: hoverHandler.hovered ? timePlate.spacing * 2 : 0

        LabelWhite {
            id: dateLabel
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: hoverHandler.hovered ? implicitWidth : 0
            clip: true
            color: "transparent"
            isClickable: false
            text: TimeService.datetime

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }

        LabelWhite {
            id: timeLabel
            isClickable: false
            text: TimeService.time
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    states: State {
        name: "mouseIn"
        when: hoverHandler.hovered == true
        PropertyChanges {
            dateLabel {
                color: Theme.white
            }
        }
    }

    transitions: Transition {
        from: "*"
        to: "mouseIn"
        reversible: true
        ColorAnimation {
            target: timeLabel
            duration: timePlate.colorChangeDuration
            easing.type: Easing.InOutCubic
        }
    }
}

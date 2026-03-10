import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../defaultCells"

DefaultCell {
    id: timePlate
    property bool isHovered: false
    required property int spacing

    states: ["mouseIn", "mouseOut"]
    state: "mouseOut"

    Layout.preferredWidth: labelLayout.width + spacing * 4

    RowLayout {
        id: labelLayout
        anchors.centerIn: timePlate
        spacing: timePlate.isHovered ? timePlate.spacing * 2 : 0

        Label {
            id: dateLabel
            Layout.alignment: Qt.AlignLeft
            clip: true

            text: Time.datetime

            font.family: "RobotoMono Nerd Font"
            font.pointSize: 14
            font.bold: true
            color: "white"

            Layout.preferredWidth: timePlate.isHovered ? implicitWidth : 0

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        Label {
            id: timeLabel
            Layout.alignment: Qt.AlignRight
            font.family: "RobotoMono Nerd Font"
            font.pointSize: 14
            font.bold: true
            clip: false
            text: Time.time
            color: "white"
        }
    }

    MouseArea {
        anchors.fill: timePlate
        hoverEnabled: true
        onContainsMouseChanged: {
            timePlate.state = containsMouse ? "mouseIn" : "mouseOut";
            timePlate.isHovered = containsMouse;
        }
    }

    transitions: [
        Transition {
            from: "mouseOut"
            to: "mouseIn"
            ColorAnimation {
                target: dateLabel
                property: "color"
                from: "transparent"
                to: "white"
                duration: 300
                easing.type: Easing.InOutCubic
            }
        },
        Transition {
            from: "mouseIn"
            to: "mouseOut"
            ColorAnimation {
                target: dateLabel
                property: "color"
                from: "white"
                to: "transparent"
                duration: 300
                easing.type: Easing.InOutCubic
            }
        }
    ]

    //     SequentialAnimation {
    //         // NumberAnimation {
    //         //     duration: 300
    //         //     easing.type: Easing.InOutCubic
    //         // }
    //         ColorAnimation {
    //             target: dateLabel
    //             property: "color"
    //             to: "white"
    //             duration: 300
    //             easing.type: Easing.InOutCubic
    //         }
    //         // NumberAnimation {
    //         //     target: dateLabel
    //         //     property: "visible"
    //         //     duration: 500
    //         // }
    //     }
    // }
}

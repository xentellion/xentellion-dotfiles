pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import "../config"

Label {
    id: root
    property bool canHover: false
    property bool runAnimation: false
    property bool isClickable: true

    property int fontSize: 16
    property int colorChangeDuration: 200

    font.family: "RobotoMono Nerd Font"
    font.pixelSize: fontSize
    font.bold: true
    clip: false
    color: Theme.white

    layer.enabled: canHover ? hover.hovered : false
    layer.effect: TextLight {
        source: root
    }

    HoverHandler {
        id: hover
    }

    property var tap: TapHandler {
        target: root
        onTapped: {
            if (root.isClickable)
                root.runAnimation = !root.runAnimation;
        }
    }

    Behavior on runAnimation {
        SequentialAnimation {
            NumberAnimation {
                target: root
                properties: "fontSize"
                to: 10
                duration: root.colorChangeDuration / 2
            }
            NumberAnimation {
                target: root
                properties: "fontSize"
                to: root.fontSize
                duration: root.colorChangeDuration / 2
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: root.colorChangeDuration
        }
    }
}

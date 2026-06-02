pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import "../config"

Label {
    id: label
    property bool canHover: false

    property int fontSize: 16
    property int colorChangeDuration: 300

    font.family: "RobotoMono Nerd Font"
    font.pixelSize: fontSize
    font.bold: true
    clip: false
    color: Theme.white

    layer.enabled: canHover ? hover.hovered : false
    layer.effect: TextLight {
        source: label
    }

    Behavior on color {
        ColorAnimation {
            duration: label.colorChangeDuration
        }
    }

    HoverHandler {
        id: hover
    }
}

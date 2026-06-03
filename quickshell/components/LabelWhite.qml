pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import "../config"

Label {
    id: label
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
        source: label
    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        id: tap
        onTapped: {
            if (label.isClickable)
                label.runAnimation = !label.runAnimation;
        }
    }

    Behavior on runAnimation {
        SequentialAnimation {
            NumberAnimation {
                target: label
                properties: "fontSize"
                to: 10
                duration: label.colorChangeDuration / 2
            }
            NumberAnimation {
                target: label
                properties: "fontSize"
                to: 16
                duration: label.colorChangeDuration / 2
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: label.colorChangeDuration
        }
    }
}

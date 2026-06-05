pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import "../config"

Slider {
    id: root

    property bool redCondition: false

    handle: Rectangle {
        id: thisHandle
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 5
        implicitHeight: 15
        radius: 1
        color: Theme.white
        border.color: Theme.textColor
    }

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: root.availableWidth
        height: implicitHeight
        radius: 2
        color: Theme.paleBackground

        Rectangle {
            id: filler
            width: root.visualPosition * parent.width
            height: parent.height
            color: root.redCondition ? Theme.urgent : Theme.white
            radius: 2
        }

        HoverHandler {
            id: hover
            cursorShape: Qt.PointingHandCursor
        }
    }
}

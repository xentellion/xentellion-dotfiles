pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../config"

Rectangle {
    id: root

    property int colorChangeDuration: 300

    Layout.preferredWidth: parent.width
    Layout.alignment: Qt.AlignHCenter

    radius: 10

    color: Theme.textColor

    border.color: Theme.cellBorder
    border.width: 2

    layer.enabled: hover.hovered
    layer.effect: TextLight {
        source: root
    }

    HoverHandler {
        id: hover
    }
}

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

    color: Theme.sideColor

    border.color: Theme.cellBorder
    border.width: 2

    property var hover: HoverHandler {}
}

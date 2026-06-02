import QtQuick
import QtQuick.Layouts

import "../config"

Rectangle {
    property int colorChangeDuration: 300

    radius: parent.height / 2
    Layout.preferredHeight: parent.height
    Layout.alignment: Qt.AlignVCenter

    color: Theme.cellColor

    border.color: Theme.cellBorder
    border.width: 2
}

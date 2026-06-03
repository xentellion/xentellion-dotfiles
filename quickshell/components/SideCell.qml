import QtQuick
import QtQuick.Layouts

import "../config"

Rectangle {
    property int colorChangeDuration: 300

    radius: 10
    Layout.preferredWidth: parent.width
    Layout.alignment: Qt.AlignHCenter

    color: Theme.textColor

    border.color: Theme.cellBorder
    border.width: 2
}

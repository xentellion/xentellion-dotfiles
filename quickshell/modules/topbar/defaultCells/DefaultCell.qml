import QtQuick
import QtQuick.Layouts

Rectangle {
    radius: parent.height / 2
    Layout.preferredHeight: parent.height
    Layout.alignment: Qt.AlignVCenter

    color: root.cellColor

    border.color: root.cellBorder
    border.width: 2
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../config"
import "../../../services"
import "../../../components"

Button {
    id: network
    background: null
    checkable: true
    Layout.preferredWidth: label.implicitWidth + spacing * 2

    LabelWhite {
        id: label
        canHover: true

        anchors.centerIn: parent
        text: Data.bluetooth
        color: BluetoothService.adapter != null ? Theme.warning : Theme.white
    }

    TapHandler {
        onTapped: {
            BluetoothService.openNetworkGui.running = true;
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

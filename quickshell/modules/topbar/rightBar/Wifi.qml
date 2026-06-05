import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../../components"
import "../../../services"

Button {
    id: network

    Layout.preferredWidth: label.implicitWidth + spacing * 2

    background: null
    checkable: true

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: NetworkService.topbarSignal
    }

    TapHandler {
        onTapped: NetworkService.openNetworkGui.running = true
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

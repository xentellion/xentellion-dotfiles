import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Bluetooth

import "../../../config"
import "../../../components"

Button {
    id: network
    property bool isActive: Bluetooth.defaultAdapter != null
    background: null
    checkable: true
    Layout.preferredWidth: label.implicitWidth + spacing * 2

    LabelWhite {
        id: label
        canHover: true

        anchors.centerIn: parent
        text: {
            let adapter = Bluetooth.defaultAdapter;
            return "󰂯";
        }
        color: network.isActive ? Theme.warning : Theme.white
    }

    TapHandler {
        onTapped: {
            openNetworkGui.running = true;
        }
    }

    Process {
        id: openNetworkGui
        command: ["blueman-manager"]
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Bluetooth

import "../../effects"
import "../../data"

Button {
    id: network
    property bool isActive: Bluetooth.defaultAdapter != null
    background: null
    checkable: true

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
        onTapped: openNetworkGui.running = true
    }

    Process {
        id: openNetworkGui
        command: ["blueman-manager"]
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

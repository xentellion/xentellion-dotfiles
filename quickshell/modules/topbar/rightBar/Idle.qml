import QtQuick.Controls
import QtQuick
import Quickshell.Wayland

import "../../../components"
import "../../../config"

Button {
    id: idler
    background: null

    checkable: true

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: Data.idleIcons[+idler.checked]
    }

    IdleInhibitor {
        // Bruh
        window: topbar
        enabled: idler.checked
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

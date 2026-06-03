import QtQuick
import Quickshell.Io
import QtQuick.Controls

import "../../../config"

Button {
    // anchors.centerIn: parent
    background: null

    Image {
        anchors.centerIn: parent
        source: Qt.resolvedUrl("../../../assets/icons/arch.png")
        fillMode: Image.Stretch
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: lmb
        acceptedButtons: Qt.RightButton
        onTapped: menuer.running = true
    }

    TapHandler {
        id: rmb
        acceptedButtons: Qt.LeftButton
        onTapped: States.menuOpen = !States.menuOpen
    }

    Process {
        id: menuer
        command: ["ignis", "toggle", "revealer-controller"]
    }
}

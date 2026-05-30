import QtQuick
import Quickshell.Io
import QtQuick.Controls

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
        onTapped: menuer.running = true
    }

    Process {
        id: menuer
        command: ["ignis", "toggle", "revealer-controller"]
    }
}

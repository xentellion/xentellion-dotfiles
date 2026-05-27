import QtQuick.Controls
import QtQuick
import Quickshell.Wayland
import "../../effects"

Button {
    id: idler
    background: null

    checkable: true

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: idler.checked ? "" : ""
    }

    IdleInhibitor {
        window: topbar
        enabled: idler.checked
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

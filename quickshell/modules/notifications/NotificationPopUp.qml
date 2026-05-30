import QtQuick
import QtQuick.Layouts
import Quickshell

PopupWindow {
    id: floatingWindow
    visible: false

    // Positioning details
    // anchor: PopupWindow.AnchorTop | PopupWindow.AnchorRight
    // margins {
    //     top: 20
    //     right: 20
    // }

    // Prevent blocking clicks on your desktop background
    // clickable: false

    // Visual bubble container
    Rectangle {
        width: 320
        height: childrenRect.height + 30
        color: "#1e1e2e" // Dark theme accent color
        border.color: "#89b4fa"
        border.width: 1
        radius: 8

        Column {
            width: parent.width - 30
            anchors.centerIn: parent
            spacing: 6

            Text {
                id: notifText
                width: parent.width
                color: "#cdd6f4"
                font.pixelSize: 14
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }
        }
    }
}

pragma ComponentBehavior: Bound

import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../../../config"

ClippingWrapperRectangle {
    id: root
    required property int spacing
    required property int rightX
    required property int myTopmargin

    property int temp: leftBlock.implicitWidth + spacing * 4
    property int delta: (root.x + temp + spacing) - rightX
    property int maxWidth: menuButton.implicitWidth + spacing * 4

    implicitWidth: Math.max(temp - Math.max(delta, 0), maxWidth)
    implicitHeight: parent.height - myTopmargin

    color: implicitWidth === maxWidth ? Theme.textColor : Theme.cellColor

    border.color: Theme.cellBorder
    border.width: 2
    radius: parent.height / 2

    clip: true

    RowLayout {
        id: leftBlock
        spacing: root.spacing * 2
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left

            rightMargin: spacing
            leftMargin: spacing
        }

        Menu {
            id: menuButton
        }
        WindowInfo {
            id: windowInfo
            elide: Text.ElideRight
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing: Easing.InOutCubic
        }
    }
}

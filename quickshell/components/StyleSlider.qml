pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import "../config"

Slider {
    id: volumeSlider

    handle: Rectangle {
        id: thisHandle
        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        implicitWidth: 5
        implicitHeight: 15
        radius: 1
        color: Theme.white
        border.color: Theme.textColor

        // Behavior on x {
        //     NumberAnimation {
        //         target: thisHandle
        //         properties: "x"
        //         duration: 100
        //         easing: Easing.InOutCubic
        //     }
        // }
    }

    background: Rectangle {
        x: volumeSlider.leftPadding
        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: volumeSlider.availableWidth
        height: implicitHeight
        radius: 2
        color: Theme.paleBackground

        Rectangle {
            id: filler
            width: volumeSlider.visualPosition * parent.width
            height: parent.height
            color: Theme.white
            radius: 2

            // Behavior on width {
            //     NumberAnimation {
            //         target: thisHandle
            //         properties: "width"
            //         duration: 100
            //         easing: Easing.InOutCubic
            //     }
            // }
        }

        HoverHandler {
            id: hover
            cursorShape: Qt.PointingHandCursor
        }
    }
}

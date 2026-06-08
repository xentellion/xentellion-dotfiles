import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../../../config"
import "../../../services"
import "../../../components"

RowLayout {
    id: root
    Layout.preferredHeight: childrenRect.height

    MenuCell {
        spacing: root.spacing
        isSquare: true
        // isClickable: true
        canHover: false
        text: Data.brightIcon

        TapHandler {
            id: rmb
            acceptedButtons: Qt.LeftButton
        }

        Component.onCompleted: {
            Layout.preferredWidth = Layout.preferredWidth;
            Layout.preferredHeight = Layout.preferredHeight;
        }
    }
    StyleSlider {
        id: slider
        Layout.fillWidth: true

        from: 1
        to: 100

        Binding {
            target: slider
            property: "value"
            value: BrightnessService.brightnessValue
            when: !slider.pressed
        }

        stepSize: 10
        snapMode: Slider.SnapAlways

        onMoved: {
            if (slider.pressed) {
                BrightnessService.setBrightness(value);
            }
        }
    }
    Item {}
}

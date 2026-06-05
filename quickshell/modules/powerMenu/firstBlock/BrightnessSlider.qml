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
        isClickable: true
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

        from: 5
        to: 100
        value: BrightnessService.brightnessValue
        Binding {
            target: slider
            property: "value"
            value: BrightnessService.brightnessValue
            when: !slider.pressed
        }

        stepSize: 5
        snapMode: Slider.SnapAlways

        onMoved: {
            BrightnessService.setBrightness(value);
        }
    }
    Item {}
}

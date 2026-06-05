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
        Layout.fillWidth: true

        from: 5
        to: 100
        value: BrightnessService.brightnessValue

        stepSize: 10
        snapMode: Slider.SnapAlways

        onValueChanged: {
            if (pressed) {
                BrightnessService.setBrightness(value);
            }
        }
    }
    Item {}
}

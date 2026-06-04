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
        text: "󰃟"

        TapHandler {
            id: rmb
            acceptedButtons: Qt.LeftButton
            // onTapped: {
            //     VolumeService.switchMute.running = true;
            // }
        }

        Component.onCompleted: {
            Layout.preferredWidth = Layout.preferredWidth;
            Layout.preferredHeight = Layout.preferredHeight;
        }
    }
    StyleSlider {
        Layout.fillWidth: true

        from: 0.0
        to: 1.0
        // value: VolumeService.audioProps ? VolumeService.audioProps.volume : 0.0

        stepSize: 0.1
        snapMode: Slider.SnapAlways

        // onValueChanged: {
        //     if (VolumeService.audioProps && pressed) {
        //         VolumeService.audioProps.volume = value;
        //     }
        // }
    }
    Item {}
}

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../../../components"

SideCell {
    id: root
    required property int spacing

    ColumnLayout {
        anchors.centerIn: parent
        implicitWidth: parent.width - root.spacing * 3
        spacing: root.spacing * 2

        BatteryShutdown {
            Layout.preferredWidth: parent.width
            spacing: root.spacing
        }
        VolumeSlider {
            Layout.preferredWidth: parent.width
            spacing: root.spacing * 2
        }
        BrightnessSlider {
            Layout.preferredWidth: parent.width
            spacing: root.spacing * 2
        }
        NetworkBluetooth {
            Layout.preferredWidth: parent.width
            spacing: root.spacing
        }
        ButtonSet {
            Layout.fillWidth: true
            spacing: root.spacing
        }
    }
}

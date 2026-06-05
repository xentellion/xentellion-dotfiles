pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../../../components"

SideCell {
    id: root
    required property int spacing

    Layout.preferredHeight: childrenRect.height + spacing * 2

    ColumnLayout {
        anchors.centerIn: parent
        implicitWidth: parent.width - root.spacing * 2
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

        RowLayout {
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width
            spacing: root.spacing

            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
        }
    }
}

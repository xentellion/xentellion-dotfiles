pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../../../config"
import "../../../services"
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
                text: "LOL"
            }
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

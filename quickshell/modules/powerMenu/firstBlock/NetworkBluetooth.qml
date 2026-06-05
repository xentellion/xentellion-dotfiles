pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../components"
import "../../../services"

RowLayout {
    id: root
    Layout.preferredHeight: childrenRect.height
    property int margin: 5

    MenuCell {
        id: network
        property bool runAnimation: false
        property int sizeDuration: 200

        spacing: root.spacing
        isClickable: true
        Layout.fillWidth: true
        Layout.preferredHeight: childrenRect.height + root.margin

        RowLayout {
            id: layout
            spacing: root.spacing
            anchors {
                left: parent.left
                right: parent.right
                centerIn: parent
            }
            Item {
                Layout.fillWidth: true
            }
            Repeater {
                model: NetworkService.wifiDevices

                delegate: WifiObject {
                    Layout.fillWidth: true
                    spacing: root.spacing
                }
            }
            Repeater {
                model: NetworkService.wiredDevices
                delegate: WiredObject {
                    Layout.fillWidth: true
                    spacing: root.spacing
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }

        TapHandler {
            id: taphandler
            onTapped: {
                network.runAnimation = !network.runAnimation;
                NetworkService.openNetworkGui.running = true;
            }
        }

        Behavior on runAnimation {
            SequentialAnimation {
                NumberAnimation {
                    target: layout
                    properties: "scale"
                    to: 0.8
                    duration: network.sizeDuration / 2
                }
                NumberAnimation {
                    target: layout
                    properties: "scale"
                    to: 1
                    duration: network.sizeDuration / 2
                }
            }
        }

        Component.onCompleted: {
            Layout.preferredWidth = Layout.preferredWidth;
        }
    }
    MenuCell {
        id: bluetooth
        Layout.preferredHeight: network.height
        spacing: root.spacing
        isClickable: true

        isSquare: true
        text: BluetoothService.adapter != null ? Data.bluetooth : Data.bluetoothOff

        fontWeightDark: 30

        TapHandler {
            onTapped: {
                BluetoothService.openNetworkGui.running = true;
            }
        }

        Component.onCompleted: {
            Layout.preferredWidth = Layout.preferredWidth;
        }
    }
}

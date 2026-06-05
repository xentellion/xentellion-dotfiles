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
        property int anyVisible: 0

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
                id: wifis
                model: NetworkService.wifiDevices

                delegate: WifiObject {
                    Layout.fillWidth: true
                    spacing: root.spacing
                    onVisibleChanged: network.updateVisibilityState()
                }
            }
            Repeater {
                id: wireds
                model: NetworkService.wiredDevices
                delegate: WiredObject {
                    Layout.fillWidth: true
                    spacing: root.spacing
                    onVisibleChanged: network.updateVisibilityState()
                }
            }
            RowLayout {
                id: noConnection
                Layout.fillWidth: true
                spacing: root.spacing
                visible: network.anyVisible === 0

                Item {
                    Layout.minimumWidth: networkIcon.width
                    LabelDark {
                        id: networkIcon
                        anchors.centerIn: parent
                        isClickable: false
                        text: Data.noNetwork
                        fontSize: 30
                    }
                }
                ColumnLayout {
                    id: wifiBlock

                    Item {
                        Layout.preferredHeight: wifiText.height
                        Layout.preferredWidth: wifiText.width

                        LabelDark {
                            id: wifiText
                            anchors.centerIn: parent
                            isClickable: false
                            text: "No connection"
                        }
                    }
                    Item {
                        Layout.preferredHeight: networkName.height
                        Layout.preferredWidth: networkName.width

                        LabelDark {
                            id: networkName
                            anchors.centerIn: parent
                            isClickable: false
                            fontSize: 12
                            text: "Go touch the grass I guess"
                        }
                    }
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }

        function updateVisibilityState() {
            let visibleCount = 0;
            for (let i = 0; i < wifis.count; i++) {
                let item = wifis.itemAt(i);
                if (item && item.visible)
                    visibleCount++;
            }
            for (let i = 0; i < wireds.count; i++) {
                let item = wireds.itemAt(i);
                if (item && item.visible)
                    visibleCount++;
            }
            anyVisible = visibleCount;
        }

        TapHandler {
            id: taphandler
            onTapped: {
                network.runAnimation = !network.runAnimation;
                NetworkService.openNetworkGui.running = true;
                States.menuOpen = false;
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
                States.menuOpen = false;
            }
        }

        Component.onCompleted: {
            Layout.preferredWidth = Layout.preferredWidth;
        }
    }
}

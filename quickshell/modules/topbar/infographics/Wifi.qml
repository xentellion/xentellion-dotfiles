import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Networking

import "../../effects"

Button {
    id: network
    property bool isVisible: true
    property var wifiConnected: ["󰤟", "󰤢", "󰤥", "󰤨"]
    property var wifiLimited: ["󰤠", "󰤣", "󰤦", "󰤩"]
    property string wifiConnecting: "󰤯"
    property string wifiUnknown: "󰤮"

    Layout.preferredWidth: label.implicitWidth + spacing * 2

    background: null
    checkable: true
    visible: network.isVisible

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: {
            let result = [];
            for (let i = 0; i < Networking.devices.values.length; i++) {
                let device = Networking.devices.values[i];
                if (device.state == ConnectionState.Disconnected || device.state == ConnectionState.Unknown) {
                    continue;
                }
                let connectivity = Networking.connectivity;

                if (device.type == DeviceType.Wifi) {
                    if (device.state == ConnectionState.Connecting || device.state == ConnectionState.Disconnecting) {
                        result.push(network.wifiConnecting);
                        continue;
                    }
                    if (device.networks.values[0] === undefined) {
                        result.push(network.wifiUnknown);
                        continue;
                    }
                    let strength = device.networks.values[0].signalStrength;
                    if (connectivity == NetworkConnectivity.Full) {
                        result.push(network.wifiConnected[Math.floor(strength / 0.25)]);
                    } else if (connectivity == NetworkConnectivity.Limited) {
                        result.push(network.wifiLimited[Math.floor(strength / 0.25)]);
                    }
                } else if (device.type == DeviceType.Wired) {
                    result.push("");
                }
            }
            if (result.length == 0) {
                result.push("");
            }
            return result.join("  ");
        }
    }

    TapHandler {
        onTapped: openNetworkGui.running = true
    }

    Process {
        id: openNetworkGui
        command: ["nmgui"]
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}

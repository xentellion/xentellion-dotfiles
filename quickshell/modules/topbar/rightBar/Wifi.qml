import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Networking

import "../../../config"
import "../../../components"

Button {
    id: network
    property bool isVisible: true

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
                        result.push(Data.wifiConnecting);
                        continue;
                    }
                    if (device.networks.values[0] === undefined) {
                        result.push(Data.wifiUnknown);
                        continue;
                    }
                    let strength = device.networks.values[0].signalStrength;
                    if (connectivity == NetworkConnectivity.Full) {
                        result.push(Data.wifiConnected[Math.floor(strength / 0.25)]);
                    } else if (connectivity == NetworkConnectivity.Limited) {
                        result.push(Data.wifiLimited[Math.floor(strength / 0.25)]);
                    }
                } else if (device.type == DeviceType.Wired) {
                    result.push(Data.wired);
                }
            }
            if (result.length == 0) {
                result.push(Data.noNetwork);
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

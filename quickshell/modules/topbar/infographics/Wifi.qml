import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Networking

import "../../effects"

Button {
    id: network
    property bool isVisible: false
    background: null
    checkable: true
    visible: network.isVisible

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: {
            for (let i = 0; i < Networking.devices.values.length; i++) {
                let device = Networking.devices.values[i];
                if (device.state == ConnectionState.Disconnected || device.state == ConnectionState.Unknown) {
                    network.isVisible = false;
                    continue;
                }
                network.isVisible = true;
                let connectivity = Networking.connectivity;

                if (device.type == DeviceType.Wifi) {
                    if (device.state == ConnectionState.Connecting || device.state == ConnectionState.Disconnecting) {
                        return " 󰤯";
                    }
                    if (device.networks.values[0] === undefined) {
                        return " 󰤮";
                    }
                    let network = device.networks.values[0].signalStrength;
                    if (connectivity == NetworkConnectivity.Full) {
                        if (device.state == ConnectionState.Connected) {
                            if (network > 0.75)
                                return " 󰤨";
                            else if (network > 0.5)
                                return " 󰤥";
                            else if (network > 0.25)
                                return " 󰤢";
                            return " 󰤟";
                        }
                    } else {
                        if (device.state == ConnectionState.Connected) {
                            if (network > 0.75)
                                return " 󰤩";
                            else if (network > 0.5)
                                return " 󰤦";
                            else if (network > 0.25)
                                return " 󰤣";
                            return " 󰤠";
                        }
                    }
                } else if (device.type == DeviceType.Wired) {
                    return "";
                }
                return "󰛵";
            }
            return "󰛵";
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

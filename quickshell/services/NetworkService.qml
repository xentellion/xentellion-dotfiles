pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

import "../config"

Singleton {
    id: root

    property var openNetworkGui: Process {
        command: ["nmgui"]
    }
    property var devices: Networking.devices

    property var wifiDevices: ScriptModel {
        values: Networking.devices.values.filter(device => {
            console.log(device);
            return device.type === DeviceType.Wifi;
        })
    }

    property var wiredDevices: ScriptModel {
        values: Networking.devices.values.filter(device => {
            return device.type === DeviceType.Wired;
        })
    }

    property var topbarSignal: {
        let result = [];
        for (let i = 0; i < devices.values.length; i++) {
            let dev = devices.values[i];
            if (dev.state == ConnectionState.Disconnected || dev.state == ConnectionState.Unknown) {
                continue;
            }
            if (dev.type == DeviceType.Wifi) {
                result.push(getWifiStrength(dev));
            } else if (dev.type == DeviceType.Wired) {
                result.push(Data.wired);
            }
        }
        if (result.length == 0) {
            result.push(Data.noNetwork);
        }
        return result.join(" ");
    }

    property var powermenuSignal: {
        for (let i = 0; i < devices.values.length; i++) {
            let dev = devices.values[i];
            if (dev.type != DeviceType.Wifi)
                continue;
            return getWifiStrength(dev);
        }
        return Data.wifiUnknown;
    }

    function getWifiStrength(device) {
        if (device.state == ConnectionState.Connecting || device.state == ConnectionState.Disconnecting) {
            return Data.wifiConnecting;
        }
        if (device.networks.values[0] === undefined) {
            return Data.wifiUnknown;
        }

        let strength = device.networks.values[0].signalStrength;

        if (Networking.connectivity == NetworkConnectivity.Full) {
            return Data.wifiConnected[Math.floor(strength / 0.25)];
        } else if (Networking.connectivity == NetworkConnectivity.Limited) {
            return Data.wifiLimited[Math.floor(strength / 0.25)];
        } else {
            return Data.wifiUnknown;
        }
    }

    function getNetworkName(device) {
        return device.networks.values[0].name;
    }
}

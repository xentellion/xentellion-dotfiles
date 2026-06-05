pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth

Singleton {
    id: root
    readonly property var adapter: Bluetooth.defaultAdapter

    readonly property var openNetworkGui: Process {
        command: ["blueman-manager"]
    }
}

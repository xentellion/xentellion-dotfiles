pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property var dimScreen: Process {
        id: dimScreen
        command: ["brightnessctl", "--save", "set", "10%"]
    }

    readonly property var restoreScreen: Process {
        id: restoreScreen
        command: ["brightnessctl", "--restore"]
    }
}

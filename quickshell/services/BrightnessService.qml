pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int brightnessValue: 0

    readonly property var dimScreen: Process {
        command: ["brightnessctl", "--save", "set", "10%"]
    }

    readonly property var restoreScreen: Process {
        command: ["brightnessctl", "--restore"]
    }

    readonly property var getBrightness: Process {
        command: ["brightnessctl", "-m"]

        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return 0;
                const list = data.trim().split(",");
                const percent = list[3].replace(/%/g, "");
                root.brightnessValue = +percent;
            }
        }
    }

    function setBrightness(value) {
        changeBrightnessScript.command = ["brightnessctl", "s", `${value}%`];
        changeBrightnessScript.running = true;
    }

    readonly property var changeBrightnessScript: Process {
        command: ["brightnessctl", "s", "50%"]
    }

    Component.onCompleted: {
        getBrightness.running = true;
    }
}

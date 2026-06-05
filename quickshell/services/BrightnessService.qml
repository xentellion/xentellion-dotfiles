pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string backlightDev: "intel_backlight"
    readonly property string sysPath: "/sys/class/backlight/" + backlightDev + "/"

    property int brightnessValue: 0

    property int curBrightness: 0
    property int maxBrightness: 0

    property FileView brightnessFile: FileView {
        id: tracker
        path: root.sysPath + "actual_brightness"
        watchChanges: true

        onFileChanged: {
            this.reload();
            root.curBrightness = +tracker.text();
            root.brightnessValue = Math.floor((root.curBrightness / root.maxBrightness) * 100);
        }
    }

    property FileView maxBrightnessFile: FileView {
        id: maxBrightnessFile
        path: root.sysPath + "max_brightness"
        blockLoading: true

        onLoaded: {
            root.maxBrightness = +maxBrightnessFile.text();
        }
    }

    readonly property var dimScreen: Process {
        command: ["brightnessctl", "--save", "set", "5%"]
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

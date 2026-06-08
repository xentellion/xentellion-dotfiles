pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string backlightDev: "intel_backlight"
    readonly property string sysPath: "/sys/class/backlight/" + backlightDev + "/"

    property int brightnessValue: 0
    property int maxBrightness: 0

    property FileView brightnessFile: FileView {
        id: tracker
        path: root.sysPath + "actual_brightness"
        watchChanges: true
        onFileChanged: {
            brightnessReadProc.running = true;
        }
    }

    property FileView maxBrightnessFile: FileView {
        id: maxBrightnessFile
        path: root.sysPath + "max_brightness"
        blockLoading: true

        onLoaded: {
            root.maxBrightness = parseInt(text());
        }
    }

    Process {
        id: brightnessReadProc
        command: ["brightnessctl", "get"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(text.trim());

                if (!isNaN(val) && root.maxBrightness > 0) {
                    root.brightnessValue = Math.floor(val / root.maxBrightness * 100);
                }
            }
        }
    }

    readonly property var dimScreen: Process {
        command: ["brightnessctl", "--save", "set", "5%"]
    }

    readonly property var restoreScreen: Process {
        command: ["brightnessctl", "--restore"]
    }

    readonly property var changeBrightnessScript: Process {
        command: ["brightnessctl", "s", "50%"]
    }

    function setBrightness(value) {
        changeBrightnessScript.command = ["brightnessctl", "s", `${value}%`];
        changeBrightnessScript.running = true;
    }

    Component.onCompleted: {
        brightnessReadProc.running = true;
    }
}

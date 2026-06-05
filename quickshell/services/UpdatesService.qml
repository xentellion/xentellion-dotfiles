pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property int updateTime: 10 * 60 * 1000

    property var updates: ListModel {}

    property var getupdates: Process {
        command: ["checkupdates"]

        onRunningChanged: {
            if (running) {
                root.updates.clear();
            }
        }

        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return null;
                const list = data.trim().split(" ");
                root.updates.append({
                    "name": list[0],
                    "version": `${list[1]} -> ${list[3]}`
                });
            }
        }
    }

    property var startUpdates: Process {
        command: ["kitty", "-e", "pkexec", "pacman", "-Syu"]
    }

    Timer {
        id: hideTimer
        interval: root.updateTime
        repeat: true
        onTriggered: {
            root.getupdates.running = true;
            console.log("Get updates");
        }
    }
}

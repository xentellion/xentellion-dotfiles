pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm");
    }

    readonly property string datetime: {
        Qt.formatDateTime(clock.date, "ddd dd MMM yyyy");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    // Process {
    //     id: dateProcess
    //     command: ["date"]
    //     running: true
    //     stdout: StdioCollector {
    //         onStreamFinished: root.time = this.text
    //     }
    // }

    // Timer {
    //     interval: 1000
    //     running: true
    //     repeat: true
    //     onTriggered: dateProcess.running = true
    // }
}

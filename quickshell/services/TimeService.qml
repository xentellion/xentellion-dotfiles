pragma Singleton

import QtQuick
import Quickshell

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
}

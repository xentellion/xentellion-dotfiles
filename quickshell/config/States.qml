pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: states

    readonly property int barHeight: 50

    property bool menuOpen: false
    property bool airplane: false
}

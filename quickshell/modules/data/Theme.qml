pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: theme

    readonly property color backgroundShadow: "#020024"

    readonly property color white: "white"
    readonly property color cellColor: "#66061840"
    readonly property color cellHighlight: "#96061840"
    readonly property color cellBorder: "#44FFFFFF"

    readonly property color textColor: "#061840"
    readonly property color textShadow: "#48061840"
    readonly property color urgent: "red"
    readonly property color warning: "yellow"
    readonly property color connected: "green"
}

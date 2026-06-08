pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: data

    // Workspace icons
    readonly property var symbolImgMap: {
        "default": "󰚀",
        "libreoffice-draw": "󰽉",
        "libreoffice-writer": "󰷈",
        "libreoffice-calc": "",
        "libreoffice-impress": "󰈩",
        "firefox": "",
        "zen": "",
        "waterfox": "",
        "org.keepassxc.KeePassXC": "",
        "vesktop": "",
        "org.telegram.desktop": "",
        "code-oss": "",
        "org.kde.dolphin": "",
        "kitty": "",
        "audacious": "",
        "obsidian": "",
        "org.mozilla.thunderbird": "",
        "v2rayN": "󰟪"
    }

    // Quotation
    readonly property var jsonData: JSON.parse(fileViewQuote.text())
    readonly property var quotes: jsonData["quotes"]

    FileView {
        id: fileViewQuote
        path: Qt.resolvedUrl("../assets/text/quotes.json")

        watchChanges: true
        onFileChanged: reload()
        blockLoading: true
    }

    function getQuote() {
        return quotes[Math.floor(Math.random() * quotes.length)];
    }

    // Wifi icons
    readonly property var wifiConnected: ["󰤟", "󰤢", "󰤥", "󰤨"]
    readonly property var wifiLimited: ["󰤠", "󰤣", "󰤦", "󰤩"]
    readonly property string wifiConnecting: "󰤯"
    readonly property string wifiUnknown: "󰤮"
    readonly property string wired: ""
    readonly property string noNetwork: ""

    // Bluetooth icons
    readonly property string bluetooth: "󰂯"
    readonly property string bluetoothOff: "󰂲"

    // Sleep icons
    readonly property var idleIcons: ["", ""]

    // Battery icons
    readonly property var batteryLevel: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹"]
    readonly property string batteryEmpty: "󰂎"
    readonly property string pluggedIcon: ""
    readonly property string chargingIcon: "󱐋"

    // Volume icons
    readonly property var volumeIcons: ["", ""]
    readonly property string volumeMute: ""
    readonly property string microhoneIcon: ""

    // Brightness icons
    readonly property string brightIcon: ""

    // Media icons
    readonly property string playerForwardIcon: ""
    readonly property string playerBackIcon: ""
    readonly property var playerPauseIcons: ["", ""]
    readonly property string playerStop: ""
}

pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: data

    // Workspace icons
    property var symbolImgMap: {
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
    property var wifiConnected: ["󰤟", "󰤢", "󰤥", "󰤨"]
    property var wifiLimited: ["󰤠", "󰤣", "󰤦", "󰤩"]
    property string wifiConnecting: "󰤯"
    property string wifiUnknown: "󰤮"
    property string wired: ""
    property string noNetwork: ""

    // Battery icons
    readonly property string batteryTemplate: "Battery level is at %1%!"
    readonly property var batteryLevel: ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰁹"]
    readonly property string batteryEmpty: "󰂎"
    readonly property string pluggedIcon: ""
    readonly property string chargingIcon: "󱐋"

    // Volume icons
    readonly property var volumeIcons: ["", ""]
    // readonly property var volumeIcons: ["󰕿", "󰖀", "󰕾"]
    readonly property string volumeMute: ""
    readonly property string microhoneIcon: ""
}

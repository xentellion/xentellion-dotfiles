import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "../../../config"
import "../../../components"
import "../../../services"

DefaultCell {
    id: lang
    required property int spacing
    property bool capsVisible: false

    implicitWidth: langdata.width + spacing * 4
    visible: LayoutService.currentLayout !== ""

    RowLayout {
        id: langdata
        anchors.centerIn: parent
        spacing: lang.capsVisible ? lang.spacing * 2 : 0

        LabelWhite {
            id: label
            text: LayoutService.currentLayout
            canHover: true

            TapHandler {
                onTapped: switchLayoutProcess.running = true
            }

            HoverHandler {
                id: hoverHandler
                cursorShape: Qt.PointingHandCursor
            }

            states: State {
                name: "mouseIn"
                when: hoverHandler.hovered == true
                PropertyChanges {
                    lang {
                        color: Theme.cellHighlight
                    }
                }
            }

            transitions: Transition {
                from: "*"
                to: "mouseIn"
                reversible: true
                ColorAnimation {
                    target: lang
                    easing.type: Easing.InOutCubic
                }
            }
        }

        LabelWhite {
            id: caps
            clip: true
            Layout.preferredWidth: lang.capsVisible ? implicitWidth : 0
            color: "transparent"
            text: "CAPS LOCK "

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Component.onCompleted: {
        Layout.preferredWidth = Layout.preferredWidth;
    }

    states: State {
        name: "capsOn"
        when: lang.capsVisible == true
        PropertyChanges {
            caps {
                color: Theme.urgent
            }
        }
    }

    transitions: Transition {
        from: "*"
        to: "capsOn"
        reversible: true
        ColorAnimation {
            target: caps
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            if (!capsProcess.running)
                capsProcess.running = true;
        }
    }

    Process {
        id: switchLayoutProcess
        command: ["hyprctl", "switchxkblayout", "current", "next"]
    }

    Process {
        id: capsProcess
        command: ["sh", "-c", "hyprctl devices -j | jq '.keyboards[] | select(.main == true) | .capsLock'"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                let temp = data === "true";
                if (lang.capsVisible != temp)
                    lang.capsVisible = temp;
            }
        }
    }
}

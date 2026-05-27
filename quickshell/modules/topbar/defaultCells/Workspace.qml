pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland

import "../../data"
import "../../effects"

Rectangle {
    id: workspace
    required property int index

    required property int defaultOpen
    required property int barHeight
    required property int spacing

    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
    property bool isHovered: false
    property bool isUrgent: ws.urgent

    property real buttonOpacity: (isHovered || isUrgent) ? 1.0 : isActive ? 0.8 : 0.5
    property int fontSize: 16

    property int activeWidth: 140
    property int inactiveWidth: 70

    property int blinkDuration: 500
    property var blinkEasing: Easing.InOutSine

    property int sizeChangeDuration: 200
    property var sizeChangeEasing: Easing.Linear

    property string wsTitle: ""

    Layout.minimumWidth: isActive ? activeWidth : inactiveWidth
    Layout.minimumHeight: barHeight / 2
    Layout.preferredWidth: winLayout.width + spacing * 2

    visible: ws || (index < defaultOpen)
    opacity: buttonOpacity

    layer.enabled: true

    radius: workspace.height / 2

    color: {
        if (typeof ws !== "undefined")
            if (workspace.isUrgent)
                return Theme.urgent;
        return Theme.white;
    }

    RowLayout {
        id: winLayout
        anchors.centerIn: workspace
        spacing: workspace.spacing

        Item {
            Layout.preferredWidth: workspaceText.width
            LabelDark {
                id: workspaceText
                anchors.centerIn: parent
                opacity: 1
                text: (workspace.ws || workspace.index < workspace.defaultOpen) ? 1 + workspace.index : ""
                font.pixelSize: workspace.fontSize
            }
        }

        Repeater {
            id: labelRepeat
            model: workspace.ws.toplevels

            Item {
                Layout.preferredWidth: workspaceText.width + workspace.spacing / 2

                required property int index
                LabelDark {
                    id: classText
                    font.pixelSize: workspace.fontSize
                    text: workspace.setWorkspaceText(parent.index)
                    anchors.centerIn: parent
                }
            }
        }
    }

    MouseArea {
        anchors.fill: workspace
        hoverEnabled: true
        onEntered: {
            workspace.isHovered = true;
        }
        onExited: {
            workspace.isHovered = false;
        }
        onClicked: {
            Hyprland.dispatch("workspace " + (workspace.index + 1));
        }
    }

    Behavior on Layout.minimumWidth {
        NumberAnimation {
            duration: workspace.sizeChangeDuration
            easing.type: workspace.sizeChangeEasing
        }
    }

    Behavior on opacity {
        OpacityAnimator {
            duration: workspace.sizeChangeDuration
        }
    }

    function setWorkspaceText(index) {
        classCollector.running = true;
        let listArray = workspace.wsTitle.split("\n");
        if (listArray[index] in Data.symbolImgMap)
            return Data.symbolImgMap[listArray[index]];
        return Data.symbolImgMap["default"];
    }

    SequentialAnimation on color {
        loops: Animation.Infinite
        running: workspace.isUrgent
        ParallelAnimation {
            ColorAnimation {
                target: workspace
                property: "color"
                to: "red"
                duration: workspace.blinkDuration
                easing.type: workspace.blinkEasing
            }
            ColorAnimation {
                target: workspaceText
                property: "color"
                to: Theme.textColor
                duration: workspace.blinkDuration
                easing.type: workspace.blinkEasing
            }
        }
        ParallelAnimation {
            ColorAnimation {
                target: workspace
                property: "color"
                to: Theme.textColor
                duration: workspace.blinkDuration
                easing.type: workspace.blinkEasing
            }
            ColorAnimation {
                targets: workspaceText
                property: "color"
                to: "white"
                duration: workspace.blinkDuration
                easing.type: workspace.blinkEasing
            }
        }
        onFinished: {
            workspaceText.color = Theme.textColor;
        }
    }

    Process {
        id: classCollector
        command: ["sh", "-c", `hyprctl clients -j | jq -r 'map(select(.workspace.id == ${workspace.index + 1})) | .[] | .initialClass'`]
        stdout: StdioCollector {
            onStreamFinished: {
                workspace.wsTitle = this.text.trim();
            }
        }
    }
}

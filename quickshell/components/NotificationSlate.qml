pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../config"
import "../components"

Item {
    id: root
    required property var modelData
    required property int spacing
    required property int radius

    readonly property int duration: 200
    readonly property int animation: Easing.OutQuad

    property bool active: false
    property bool startVisible: false

    Layout.fillWidth: true
    implicitHeight: 60
    rotation: 180
    clip: true

    SideCell {
        id: sample
        width: parent.width
        height: parent.height
        radius: Math.floor(root.radius / 2)
        clip: true
        visible: root.startVisible

        x: root.active ? 0 : -width

        Behavior on x {
            NumberAnimation {
                target: sample
                properties: "x"
                duration: root.duration
                easing.type: root.animation
            }
        }

        border.color: {
            switch (root.modelData.urgency) {
            case NotificationUrgency.Critical:
                {
                    return Theme.urgent;
                }
            case NotificationUrgency.Low:
                {
                    return Theme.warning;
                }
            default:
                return Theme.cellBorder;
            }
        }

        RowLayout {
            anchors.fill: sample
            anchors.margins: root.spacing
            spacing: logo.visible ? root.spacing : 0

            Image {
                id: logo
                Layout.fillHeight: true
                Layout.preferredWidth: parent.height
                fillMode: Image.PreserveAspectFit
                source: root.modelData.image
                visible: root.modelData.image !== ""
            }

            ClippingRectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height
                color: "transparent"
                LabelWhite {
                    font.bold: false
                    fontSize: 14
                    text: `<b>${root.modelData.summary}</b><br>${root.modelData.body}`
                }
            }
        }

        TapHandler {
            onTapped: {
                root.deactivate();
            }
        }
    }

    function deactivate() {
        root.active = false;
        removalTimer.start();
    }

    Timer {
        id: activationTimer
        interval: root.duration
        running: false
        repeat: false
        onTriggered: {
            root.startVisible = true;
            root.active = true;
        }
    }
    Timer {
        id: removalTimer
        interval: root.duration
        running: false
        repeat: false
        onTriggered: {
            root.modelData.dismiss();
        }
    }

    Component.onCompleted: {
        activationTimer.start();
    }
}

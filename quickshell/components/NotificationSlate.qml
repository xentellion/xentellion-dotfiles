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

    property int currentHeight: messageText.contentHeight

    Layout.fillWidth: true
    Layout.minimumHeight: 60
    Layout.preferredHeight: currentHeight

    rotation: 180
    clip: true

    Behavior on currentHeight {
        NumberAnimation {
            duration: root.duration
            easing.type: root.animation
        }
    }

    MenuCell {
        id: sample
        spacing: root.spacing
        property int currentX: root.active ? 0 : -width

        width: parent.width
        height: parent.height
        radius: root.radius
        visible: root.startVisible
        clip: true

        x: currentX

        Behavior on currentX {
            id: heightBehavior
            NumberAnimation {
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
        border.width: 3

        RowLayout {
            anchors.fill: sample
            anchors.margins: root.spacing
            spacing: logo.visible ? root.spacing : 0

            Item {
                Layout.fillHeight: true

                Layout.preferredWidth: parent.height
                Layout.maximumWidth: 60
                visible: root.modelData.image !== ""

                ClippingRectangle {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                    }
                    height: parent.width
                    radius: Math.floor(width / 4)
                    color: "transparent"

                    Image {
                        id: logo
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: root.modelData.image

                        layer.enabled: true
                        layer.effect: TextShadow {
                            source: logo
                        }
                    }
                }
            }

            ClippingRectangle {
                Layout.fillWidth: true
                Layout.minimumHeight: parent.height
                color: "transparent"

                LabelDark {
                    id: messageText
                    anchors.fill: parent
                    font.bold: false
                    fontSize: 14
                    text: `<b>${root.modelData.summary}</b><br>${root.modelData.body}`
                    wrapMode: Text.Wrap
                    elide: textHover.hovered ? false : Text.ElideRight
                }
            }
        }

        TapHandler {
            onTapped: {
                root.deactivate();
            }
        }

        HoverHandler {
            id: textHover
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

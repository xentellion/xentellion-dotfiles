pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import Quickshell.Services.SystemTray

import "../../../components"

SideCell {
    id: root

    required property int spacing

    visible: SystemTray.items.values.length > 0

    RowLayout {
        anchors.centerIn: parent
        spacing: root.spacing
        Repeater {
            model: SystemTray.items
            delegate: Image {
                id: sample
                required property var modelData
                property bool runAnimation: false
                property int animDuration: 200

                source: modelData.icon
                sourceSize.width: 24
                sourceSize.height: 24

                layer.enabled: hover.hovered
                layer.effect: TextLight {
                    source: sample
                }

                HoverHandler {
                    id: hover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: tap
                    acceptedButtons: Qt.LeftButton

                    onTapped: {
                        sample.modelData.activate();
                        sample.runAnimation = !sample.runAnimation;
                    }
                }

                // TapHandler {
                //     id: rtap
                //     acceptedButtons: Qt.RightButton

                //     onTapped: {
                //         if (sample.modelData.hasMenu) {
                //             sample.modelData.display(parent, point.position.x, point.position.y);
                //         }
                //     }
                // }

                Behavior on runAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: sample
                            properties: "scale"
                            to: 0.6
                            duration: sample.animDuration / 2
                        }
                        NumberAnimation {
                            target: sample
                            properties: "scale"
                            to: 1
                            duration: sample.animDuration / 2
                        }
                    }
                }
            }
        }
    }
}

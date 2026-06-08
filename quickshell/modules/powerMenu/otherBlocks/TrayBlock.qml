pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import Quickshell.Services.SystemTray

import "../../../config"
import "../../../components"

SideCell {
    id: root

    required property int spacing

    color: Theme.cellColor
    visible: SystemTray.items.values.length > 0

    RowLayout {
        anchors.centerIn: parent
        spacing: root.spacing
        Repeater {
            model: SystemTray.items
            delegate: Image {
                id: sample
                required property var modelData

                source: modelData.icon
                sourceSize.width: 24
                sourceSize.height: 24

                layer.enabled: hover.hovered
                layer.effect: TextLight {
                    source: sample
                }

                HoverHandler {
                    id: hover
                }

                TapHandler {
                    id: tap
                    acceptedButtons: Qt.LeftButton

                    onTapped: {
                        sample.modelData.activate();
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
            }
        }
    }
}

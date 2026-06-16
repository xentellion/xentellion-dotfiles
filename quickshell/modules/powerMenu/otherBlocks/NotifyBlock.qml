pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "../../../components"
import "../../../services"

SideCell {
    id: root
    required property int spacing

    ClippingRectangle {
        anchors.fill: parent
        anchors.margins: root.spacing
        color: "transparent"

        ColumnLayout {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            spacing: root.spacing
            rotation: 180
            Item {
                Layout.fillHeight: true
            }
            Repeater {
                id: notificationList
                clip: true

                model: NotificationService.notify.trackedNotifications

                delegate: NotificationSlate {
                    id: slate
                    radius: root.radius
                    spacing: root.spacing
                }
            }
            LabelWhite {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                canHover: true
                isClickable: true

                rotation: 180
                text: "Clear notifications"

                TapHandler {
                    onTapped: {
                        for (let i = 0; i < notificationList.count; i++) {
                            let item = notificationList.itemAt(i);
                            if (item !== null) {
                                (item as NotificationSlate).deactivate();
                            }
                        }
                    }
                }
            }
        }
    }
}

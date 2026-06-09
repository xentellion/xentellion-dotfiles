pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../../../config"
import "../../../components"
import "../../../services"

SideCell {
    id: root
    required property int spacing

    color: Theme.cellColor

    ColumnLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        anchors.margins: root.spacing
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
                        var item = notificationList.itemAt(i);
                        if (item) {
                            item.deactivate(); // Вызываем функцию самого элемента
                        }
                    }
                }
            }
        }
    }
}

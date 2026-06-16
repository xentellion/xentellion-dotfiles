pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../../config"
import "../../services"
import "../../components"

PanelWindow {
    id: root

    readonly property int popupWidth: 400
    readonly property int spacing: 10

    anchors {
        top: true
        right: true
    }

    exclusionMode: ExclusionMode.Normal

    implicitWidth: popupWidth + spacing
    implicitHeight: popupList.height
    color: "transparent"

    ListView {
        id: popupList
        implicitWidth: parent.width
        implicitHeight: childrenRect.height
        spacing: root.spacing

        model: NotificationService.notify.trackedNotifications

        delegate: SideCell {
            id: source

            required property var modelData

            implicitWidth: root.popupWidth
            implicitHeight: 80
            Layout.preferredWidth: implicitWidth

            border.color: {
                switch (modelData.urgency) {
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
                anchors.fill: source
                anchors.margins: root.spacing * 2
                spacing: logo.visible ? root.spacing : 0

                Image {
                    id: logo
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.height
                    fillMode: Image.PreserveAspectFit
                    source: source.modelData.image
                    visible: source.modelData.image !== ""
                }

                ClippingRectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: "transparent"
                    LabelWhite {
                        font.bold: false
                        fontSize: 16
                        text: `<b>${source.modelData.summary}</b><br>${source.modelData.body}`
                        wrapMode: Text.WordWrap
                    }
                }
            }

            TapHandler {
                onTapped: {
                    source.modelData.dismiss();
                }
            }

            Timer {
                id: hideTimer
                interval: 5000
                running: true
                repeat: false
                onTriggered: {
                    source.visible = false;
                    source.implicitHeight = 0;
                }
            }
        }
    }
}

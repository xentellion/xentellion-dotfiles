pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

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

    implicitWidth: popupWidth
    implicitHeight: popupList.height
    color: "transparent"

    ListView {
        id: popupList
        width: parent.width
        height: childrenRect.height
        spacing: root.spacing

        model: NotificationService.notify.trackedNotifications

        delegate: SideCell {
            id: source
            implicitWidth: root.popupWidth
            implicitHeight: 80
            required property var modelData

            RowLayout {
                anchors.fill: source
                anchors.margins: root.spacing
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
                        fontSize: 14
                        text: `<b>${source.modelData.summary}</b><br>${source.modelData.body}`
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

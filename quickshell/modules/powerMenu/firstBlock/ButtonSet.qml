pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "../../../config"
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root
    Layout.preferredHeight: content.height + (updatesTable.visible ? updatesTable.height + spacing * 2 : 0)

    RowLayout {
        id: content
        spacing: root.spacing

        MenuCell {
            id: updates
            spacing: root.spacing
            Layout.fillWidth: true
            text: "󰚰 " + UpdatesService.updates.count
            isClickable: true

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: {
                    updatesTable.isVisible = !updatesTable.isVisible;
                }
            }

            Component.onCompleted: {
                Layout.preferredWidth = Layout.preferredWidth;
                Layout.preferredHeight = Layout.preferredHeight;
            }
        }
        MenuCell {
            id: powerProfiles
            spacing: root.spacing
            Layout.fillWidth: true
            isClickable: true
            text: "power-profiles"

            TapHandler {
                acceptedButtons: Qt.LeftButton
                onTapped: {
                    updatesTable.isVisible = false;
                }
            }

            Component.onCompleted: {
                Layout.preferredWidth = Layout.preferredWidth;
                Layout.preferredHeight = Layout.preferredHeight;
            }
        }
        MenuCell {
            id: plane
            spacing: root.spacing
            Layout.fillWidth: true
            isClickable: true
            text: ""
            textColor: States.airplane ? Theme.textColor : Theme.cellColor

            TapHandler {
                onTapped: {
                    if (States.airplane) {
                        NetworkService.airplaneOff.running = true;
                    } else {
                        NetworkService.airplaneOn.running = true;
                    }
                    updatesTable.isVisible = false;
                }
            }

            Component.onCompleted: {
                Layout.preferredWidth = Layout.preferredWidth;
                Layout.preferredHeight = Layout.preferredHeight;
            }
        }
    }

    Rectangle {
        id: updatesTable
        property bool isVisible: false

        Layout.fillWidth: true
        Layout.preferredHeight: isVisible ? 220 : 0
        radius: 20
        clip: true

        ColumnLayout {
            spacing: root.spacing
            anchors {
                fill: parent
                leftMargin: 15
                rightMargin: 15
                topMargin: 5
                bottomMargin: 10
            }

            ClippingWrapperRectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: list
                    anchors.fill: parent
                    anchors.margins: 10

                    model: UpdatesService.updates
                    delegate: Text {
                        id: theText
                        required property string name
                        required property string version
                        text: `<b>${name}</b> -> ${version}`
                        color: Theme.textColor
                        font.pixelSize: 16

                        layer.enabled: true
                        layer.effect: TextShadow {
                            source: theText
                        }
                    }

                    HoverHandler {
                        id: hover
                    }
                }
            }

            DefaultCell {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                color: Theme.textColor

                LabelWhite {
                    isClickable: true
                    canHover: true
                    anchors.fill: parent

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: "Update"
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton
                    onTapped: {
                        updatesTable.isVisible = false;
                        States.menuOpen = false;
                        UpdatesService.startUpdates.running = true;
                    }
                }
            }
        }

        Behavior on Layout.preferredHeight {
            NumberAnimation {
                duration: 200
                easing: Easing.InOutCubic
            }
        }

        Component.onCompleted: {
            UpdatesService.getupdates.running = true;
        }
    }
}

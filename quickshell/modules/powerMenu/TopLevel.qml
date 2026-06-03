pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

import "../../config"
import "../../components"

SideCell {
    id: root
    required property int spacing

    Layout.preferredHeight: childrenRect.height + spacing * 2

    ColumnLayout {
        anchors.centerIn: parent
        implicitWidth: parent.width - root.spacing * 2
        spacing: root.spacing * 2

        RowLayout {
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width
            spacing: root.spacing

            MenuCell {
                spacing: root.spacing
                text: "LOL"
            }
            Item {
                Layout.fillWidth: true
            }
            MenuCell {
                id: rebootButton
                spacing: root.spacing
                // isSquare: true
                text: ""

                TapHandler {
                    onTapped: {
                        reboot.running = true;
                    }
                }
            }
            MenuCell {
                id: shutdownButton
                spacing: root.spacing
                // isSquare: true
                text: ""

                TapHandler {
                    onTapped: {
                        shutdown.running = true;
                    }
                }
            }
        }

        RowLayout {
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width
            spacing: root.spacing

            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                text: "LOL"
            }
        }
        RowLayout {
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width
            spacing: root.spacing * 2
            MenuCell {
                spacing: root.spacing
                isSquare: true
                text: "0"
            }
            Slider {
                Layout.fillWidth: true
            }
        }
        RowLayout {
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width
            spacing: root.spacing * 2
            MenuCell {
                spacing: root.spacing
                isSquare: true
                text: "0"
            }
            Slider {
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width
            spacing: root.spacing

            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
            MenuCell {
                spacing: root.spacing
                Layout.fillWidth: true
                text: "LOL"
            }
        }
    }

    Process {
        id: shutdown
        command: ["shutdown", "now"]
    }

    Process {
        id: reboot
        command: ["reboot"]
    }
}

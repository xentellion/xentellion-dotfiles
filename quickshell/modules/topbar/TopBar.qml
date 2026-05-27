pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "clock"
import "defaultCells"
import "infographics"
import "../data"

Scope {
    id: root

    property int spacing: 10
    property int barHeight: 50

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: topbar
            required property var modelData
            color: "transparent"

            implicitWidth: screen.width
            implicitHeight: root.barHeight

            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent

                MarginWrapperManager {
                    margin: 5
                }

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Theme.backgroundShadow
                    }
                    GradientStop {
                        position: 0.9
                        color: "transparent"
                    }
                }

                Item {
                    RowLayout {
                        spacing: root.spacing
                        anchors.fill: parent

                        DefaultCell {
                            id: leftBar
                            Layout.alignment: Qt.AlignLeft
                            Layout.preferredWidth: 200
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        DefaultCell {
                            id: workspaceBar
                            Layout.preferredWidth: childrenRect.width + 9 * 2

                            Layout.alignment: Qt.AlignLeft

                            RowLayout {
                                spacing: root.spacing
                                anchors {
                                    centerIn: parent
                                }

                                Repeater {
                                    Layout.alignment: Qt.AlignCenter
                                    model: 10
                                    Workspace {
                                        defaultOpen: 5
                                        spacing: root.spacing
                                        barHeight: root.barHeight
                                    }
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }

                        Language {
                            id: languageLayout
                            spacing: root.spacing
                            Layout.alignment: Qt.AlignRight
                        }
                        DefaultCell {
                            id: rightBar
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: childrenRect.width + root.spacing * 4

                            RowLayout {
                                anchors {
                                    top: parent.top
                                    bottom: parent.bottom
                                    centerIn: parent
                                }

                                Idle {}
                                Wifi {}
                                Bluetooth {}
                                Volume {
                                    spacing: root.spacing
                                }
                            }
                        }
                        Clock {
                            id: timePlate
                            spacing: root.spacing
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
            }
        }
    }
}

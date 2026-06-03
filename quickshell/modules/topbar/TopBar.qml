pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../../config"
import "../../components"
import "leftBar"
import "centerBar"
import "rightBar"

Scope {
    id: topbarBase

    property int spacing: 10
    property int barHeight: 50

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: topbar
            required property var modelData
            color: "transparent"

            implicitWidth: screen.width
            implicitHeight: topbarBase.barHeight

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
                        spacing: topbarBase.spacing
                        anchors.fill: parent

                        DefaultCell {
                            id: leftBar
                            Layout.alignment: Qt.AlignLeft
                            Layout.preferredWidth: childrenRect.width + topbarBase.spacing * 4

                            RowLayout {
                                spacing: topbarBase.spacing * 2
                                anchors {
                                    centerIn: parent
                                }

                                Menu {}
                                WindowInfo {}
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        DefaultCell {
                            id: workspaceBar
                            Layout.preferredWidth: childrenRect.width + 9 * 2

                            Layout.alignment: Qt.AlignLeft

                            RowLayout {
                                spacing: topbarBase.spacing
                                anchors.centerIn: parent

                                Repeater {
                                    Layout.alignment: Qt.AlignCenter
                                    model: 10
                                    Workspace {
                                        defaultOpen: 5
                                        spacing: topbarBase.spacing
                                        barHeight: topbarBase.barHeight
                                    }
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }

                        Language {
                            id: languageLayout
                            spacing: topbarBase.spacing
                            Layout.alignment: Qt.AlignRight
                        }
                        DefaultCell {
                            id: rightBar
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: childrenRect.width + topbarBase.spacing * 4

                            RowLayout {
                                anchors {
                                    top: parent.top
                                    bottom: parent.bottom
                                    centerIn: parent
                                }

                                Idle {}
                                Wifi {}
                                Bluetooth {}
                                Microphone {}
                                Volume {}
                            }
                        }
                        Battery {
                            id: battery
                            spacing: topbarBase.spacing
                            Layout.alignment: Qt.AlignRight
                        }
                        Clock {
                            id: timePlate
                            spacing: topbarBase.spacing
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
            }
        }
    }
}

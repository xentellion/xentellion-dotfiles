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
    property int margin: 5
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
                    margin: topbarBase.margin
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
                    DefaultCell {
                        id: leftBar
                        anchors {
                            top: parent.top
                            left: parent.left
                        }
                        implicitWidth: leftBlock.width + topbarBase.spacing * 4
                        height: parent.height

                        RowLayout {
                            id: leftBlock
                            spacing: topbarBase.spacing * 2
                            anchors {
                                centerIn: parent
                            }

                            Menu {}
                            WindowInfo {}
                        }
                    }

                    DefaultCell {
                        id: workspaceBar
                        anchors {
                            top: parent.top
                        }

                        width: centerBlocks.width + topbarBase.spacing * 2
                        height: parent.height
                        radius: Math.floor(height / 2)

                        property int leftmost: leftBar.x + leftBar.width + topbarBase.spacing
                        property int perfectHalf: Math.floor((topbar.width - workspaceBar.width) / 2)

                        x: Math.max(leftmost, perfectHalf)
                        // If amount of open windows starts to get overwhelming - its only YOUR fault

                        RowLayout {
                            id: centerBlocks
                            anchors.centerIn: parent
                            spacing: topbarBase.spacing

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

                    RowLayout {
                        id: rightBar
                        spacing: topbarBase.spacing
                        anchors {
                            top: parent.top
                            right: parent.right
                        }
                        height: parent.height

                        Language {
                            id: languageLayout
                            spacing: topbarBase.spacing
                            Layout.alignment: Qt.AlignRight
                        }
                        DefaultCell {
                            id: dataBlock
                            Layout.alignment: Qt.AlignRight
                            Layout.preferredWidth: childrenRect.width + topbarBase.spacing * 3

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

                    // RowLayout {
                    //     spacing: topbarBase.spacing
                    //     anchors.fill: parent

                    // Item {
                    //     id: leftSpacer
                    //     property real trueCenterLeft: (topbar.width - workspaceBar.width) / 2
                    //     property real rightPushLeft: leftBar.x + workspaceBar.width - topbarBase.spacing
                    //     Layout.preferredWidth: Math.min(trueCenterLeft, rightPushLeft) - leftBar.width + topbarBase.spacing
                    // }

                    // Item {
                    //     id: rightSpacer
                    //     Layout.fillWidth: true
                    // }
                    // }
                }
            }
        }
    }
}

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
    id: root

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
            implicitHeight: root.barHeight

            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent

                MarginWrapperManager {
                    margin: root.margin
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
                    CenterBar {
                        id: workspaceBar
                        spacing: root.spacing
                        maxWidth: topbar.width
                        maxHeight: root.barHeight
                        rightX: rightBar.x
                    }

                    LeftBar {
                        id: leftBar
                        spacing: root.spacing
                        rightX: workspaceBar.x
                        myTopmargin: root.margin
                    }

                    RightBar {
                        id: rightBar
                        spacing: root.spacing
                    }
                }
            }
        }
    }
}

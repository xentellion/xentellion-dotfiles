pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../../config"
import "../../components"

Scope {
    id: powermenuBase

    readonly property int width: 400
    readonly property int margin: 5
    readonly property int spacing: 10
    readonly property int windowSpacing: 5

    readonly property var hyperAnimations: {
        "easeOutQuint": [0.23, 1, 0.32, 1],
        "easeInOutCubic": [0.65, 0.05, 0.36, 1],
        "linear": [0, 0, 1, 1],
        "almostLinear": [0.5, 0.5, 0.75, 1.0],
        "quick": [0.15, 0, 0.1, 1]
    }

    readonly property int animationsDuration: 173
    readonly property int animationsEasing: Easing.Linear
    readonly property int sliderDuration: 3000

    PanelWindow {
        id: powermenu

        implicitHeight: screen.height
        implicitWidth: powermenuBase.width

        exclusionMode: ExclusionMode.Normal
        // exclusionMode: States.menuOpen ? ExclusionMode.Auto : ExclusionMode.Normal
        // aboveWindows: false

        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
        }

        Item {
            id: box
            width: powermenu.width
            x: -width

            MarginWrapperManager {
                topMargin: powermenuBase.margin
                leftMargin: powermenuBase.margin
                rightMargin: powermenuBase.margin
                bottomMargin: powermenuBase.margin
            }

            Item {
                ColumnLayout {
                    anchors.fill: parent
                    spacing: powermenuBase.windowSpacing

                    TopLevel {
                        spacing: powermenuBase.spacing
                    }
                    SideCell {
                        Layout.preferredHeight: childrenRect.height + powermenuBase.spacing
                        LabelWhite {
                            anchors.centerIn: parent
                            text: "LMAO"
                        }
                    }
                }
            }

            states: [
                State {
                    name: "opened"
                    when: States.menuOpen
                    PropertyChanges {
                        box {
                            x: 0
                        }
                    }
                }
            ]

            transitions: [
                Transition {
                    from: ""
                    to: "opened"
                    reversible: true
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                console.log(powermenu.aboveWindows + " " + States.menuOpen);
                                powermenu.aboveWindows = States.menuOpen;
                            }
                        }
                        NumberAnimation {
                            target: box
                            properties: "x"
                            duration: powermenuBase.animationsDuration
                            easing.type: powermenuBase.animationsEasing
                        }
                    }
                }
            ]
        }

        HoverHandler {
            id: hoverHandler
            // cursorShape: Qt.PointingHandCursor
            onHoveredChanged: {
                if (hovered) {
                    hideTimer.stop();
                } else {
                    hideTimer.start();
                }
            }
        }

        Timer {
            id: hideTimer
            interval: powermenuBase.sliderDuration
            repeat: false
            onTriggered: {
                States.menuOpen = false;
            }
        }
    }
}

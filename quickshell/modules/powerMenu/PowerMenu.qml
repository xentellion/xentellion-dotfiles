pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../../config"
import "firstBlock"
import "../../components"

Scope {
    id: powermenuBase

    readonly property int width: 400
    readonly property int margin: 10
    readonly property int spacing: 10
    readonly property int windowSpacing: 5

    readonly property int animationsDuration: 173
    readonly property int animationsEasing: Easing.Linear
    readonly property int sliderDuration: 1500

    readonly property int visibilityState: States.menuOpen

    LazyLoader {
        id: lazySidebar
        loading: true
        PanelWindow {
            id: powermenu

            implicitHeight: screen.height
            implicitWidth: powermenuBase.width

            exclusionMode: ExclusionMode.Normal
            aboveWindows: false

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
                height: parent.height

                MarginWrapperManager {
                    topMargin: Math.floor(powermenuBase.margin / 2)
                    leftMargin: Math.floor(powermenuBase.margin / 2)
                    rightMargin: powermenuBase.margin
                    bottomMargin: powermenuBase.margin
                }

                Item {
                    ColumnLayout {
                        id: column
                        anchors.fill: parent
                        spacing: powermenuBase.windowSpacing

                        TopLevel {
                            id: toplevel
                            spacing: powermenuBase.spacing
                        }
                        SideCell {
                            id: media
                            Layout.preferredHeight: childrenRect.height + powermenuBase.spacing
                            LabelWhite {
                                anchors.centerIn: parent
                                text: "TODO: MEDIA"
                            }
                        }
                        SideCell {
                            id: notifications
                            Layout.minimumHeight: childrenRect.height + powermenuBase.spacing
                            Layout.fillHeight: true
                            color: Theme.cellColor
                            LabelWhite {
                                anchors.centerIn: parent
                                text: "TODO: Notifications"
                            }
                        }
                        // Item {
                        //     Layout.fillHeight: true
                        // }
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
}

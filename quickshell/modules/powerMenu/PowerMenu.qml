pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

import "../../config"
import "firstBlock"
import "otherBlocks"

Scope {
    id: root

    readonly property int width: 420
    readonly property int margin: 10
    readonly property int spacing: 10
    readonly property int windowSpacing: 5

    readonly property int animationsDuration: 400
    readonly property int animationsEasing: Easing.InOutExpo
    readonly property int sliderDuration: 1500

    readonly property int visibilityState: States.menuOpen

    LazyLoader {
        id: lazySidebar
        loading: true
        PanelWindow {
            id: powermenu

            implicitHeight: screen.height
            implicitWidth: root.width

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

                ScrollView {
                    id: scrollView
                    anchors.fill: parent
                    anchors {
                        topMargin: 2
                        bottomMargin: 2
                        leftMargin: 10
                        rightMargin: 10
                    }
                    clip: true
                    contentHeight: column.implicitHeight + anchors.topMargin + anchors.bottomMargin + root.spacing

                    ColumnLayout {
                        id: column
                        anchors.fill: parent
                        spacing: root.windowSpacing
                        anchors.topMargin: 5
                        anchors.bottomMargin: 5

                        TopLevel {
                            id: toplevel
                            Layout.preferredHeight: toplevel.childrenRect.height + root.spacing * 2
                            Layout.fillWidth: true

                            spacing: root.spacing
                        }

                        Repeater {
                            id: medias
                            model: Mpris.players
                            delegate: MediaBlock {
                                id: media

                                Layout.preferredHeight: media.childrenRect.height + root.spacing * 2
                                Layout.fillWidth: true
                                spacing: root.spacing
                            }
                        }
                        TrayBlock {
                            id: tray
                            Layout.fillWidth: true
                            Layout.preferredHeight: childrenRect.height + root.spacing
                            spacing: root.spacing
                        }
                        NotifyBlock {
                            id: notifications
                            property int recomendedEmptyHeight: {
                                let blocks = powermenu.implicitHeight - toplevel.height - tray.height - States.barHeight;
                                let space = root.spacing * (tray.visible ? 3 : 2);
                                return blocks - space;
                            }
                            property int recomendedFullHeight: Math.floor(powermenu.implicitHeight * 0.5)

                            property int playerCount: {
                                let counter = 0;
                                for (let i = 0; i < Mpris.players.values.length; i++) {
                                    if (medias.model.values[i].playbackState !== MprisPlaybackState.Stopped) {
                                        counter++;
                                    }
                                }
                                return counter;
                            }

                            Layout.preferredHeight: playerCount === 0 ? recomendedEmptyHeight : recomendedFullHeight
                            spacing: root.spacing
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
                                    powermenu.aboveWindows = States.menuOpen;
                                }
                            }
                            NumberAnimation {
                                target: box
                                properties: "x"
                                duration: root.animationsDuration
                                easing.type: root.animationsEasing
                            }
                        }
                    }
                ]
            }

            HoverHandler {
                id: hoverHandler
                // onHoveredChanged: {
                //     if (hovered) {
                //         hideTimer.stop();
                //     } else {
                //         hideTimer.start();
                //     }
                // }
            }

            // Timer {
            //     id: hideTimer
            //     interval: powermenuBase.sliderDuration
            //     repeat: false
            //     onTriggered: {
            //         States.menuOpen = false;
            //     }
            // }
        }
    }
}

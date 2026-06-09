pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

import "../../../config"
import "../../../components"

SideCell {
    id: root
    required property int spacing
    required property MprisPlayer modelData

    property int buttonSize: 40

    visible: modelData.playbackState !== MprisPlaybackState.Stopped

    ColumnLayout {
        id: elements
        anchors.centerIn: parent
        anchors.margins: 15
        implicitWidth: parent.width
        spacing: root.spacing

        RowLayout {
            id: coverArea
            implicitWidth: parent.width
            Layout.preferredHeight: childrenRect.height
            spacing: root.spacing

            ClippingRectangle {
                id: cover
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                Layout.maximumHeight: 200

                Layout.leftMargin: root.spacing
                Layout.rightMargin: root.spacing
                color: "transparent"
                radius: root.radius
                clip: true

                Image {
                    id: logo
                    anchors.fill: parent
                    source: Qt.resolvedUrl(root.modelData.trackArtUrl)
                    fillMode: Image.PreserveAspectCrop
                }
                visible: root.modelData.trackArtUrl !== ""
            }
        }

        ClippingRectangle {
            id: titleBox
            color: "transparent"
            Layout.fillWidth: true
            Layout.preferredHeight: title.height
            Layout.maximumWidth: parent.width - root.spacing * 2

            Layout.leftMargin: root.spacing
            Layout.rightMargin: root.spacing

            clip: true

            LabelWhite {
                id: title
                anchors.verticalCenter: parent.verticalCenter
                text: root.modelData.trackTitle
                isClickable: false

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                property int duration: 3000
                property var easing: Easing.InOutQuad
                property int startingX: 10

                onTextChanged: {
                    resetMarquee();
                }

                SequentialAnimation on x {
                    id: bounceAnim
                    loops: Animation.Infinite
                    running: title.paintedWidth > (titleBox.width - 20)

                    PauseAnimation {
                        duration: title.duration
                    }

                    NumberAnimation {
                        to: titleBox.width - title.paintedWidth - 10
                        duration: Math.max(1000, (title.paintedWidth - titleBox.width) * 15)
                        easing.type: title.easing
                    }

                    PauseAnimation {
                        duration: title.duration
                    }

                    NumberAnimation {
                        to: 10
                        duration: Math.max(1000, (title.paintedWidth - titleBox.width) * 15)
                        easing.type: title.easing
                    }
                }

                function resetMarquee() {
                    bounceAnim.stop();
                    title.x = startingX;
                    bounceAnim.restart();
                }
            }
        }

        StyleSlider {
            id: slider
            Layout.fillWidth: true
            Layout.leftMargin: root.spacing
            Layout.rightMargin: root.spacing

            from: 0
            to: 100

            Binding {
                target: slider
                property: "value"
                value: Math.floor(root.modelData.position / root.modelData.length * 100)
                when: !slider.pressed
            }

            onValueChanged: {
                if (pressed) {
                    Math.floor(root.modelData.position = value / 100 * root.modelData.length);
                }
            }
        }
        RowLayout {
            id: commandButtons
            Layout.fillWidth: true
            Layout.preferredHeight: childrenRect.height
            // spacing: root.spacing

            Layout.leftMargin: root.spacing
            Layout.rightMargin: root.spacing

            LabelWhite {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: `${root.formatSeconds(root.modelData.position)} / ${root.formatSeconds(root.modelData.length)}`

                FrameAnimation {
                    running: root.modelData.playbackState == MprisPlaybackState.Playing
                    onTriggered: root.modelData.positionChanged()
                }

                Timer {
                    running: (root.modelData.playbackState == MprisPlaybackState.Playing) && (States.menuOpen == true)
                    interval: 1000
                    repeat: true
                    onTriggered: root.modelData.positionChanged()
                }
            }
            Item {
                Layout.fillWidth: true
            }
            MenuCell {
                id: previous
                Layout.preferredWidth: root.buttonSize
                spacing: root.spacing
                text: Data.playerBackIcon
                canHover: true
                isClickable: true

                Component.onCompleted: {
                    Layout.preferredWidth = Layout.preferredWidth;
                    Layout.preferredHeight = Layout.preferredHeight;
                }

                TapHandler {
                    onTapped: {
                        if (root.modelData.canGoPrevious) {
                            root.modelData.previous();
                        }
                        title.resetMarquee();
                    }
                }
            }
            MenuCell {
                Layout.preferredWidth: root.buttonSize
                spacing: root.spacing
                text: Data.playerPauseIcons[+root.modelData.isPlaying]
                canHover: true
                isClickable: true

                TapHandler {
                    onTapped: {
                        if (root.modelData.canTogglePlaying) {
                            root.modelData.togglePlaying();
                        }
                    }
                }

                Component.onCompleted: {
                    Layout.preferredWidth = Layout.preferredWidth;
                    Layout.preferredHeight = Layout.preferredHeight;
                }
            }
            MenuCell {
                Layout.preferredWidth: root.buttonSize
                spacing: root.spacing
                text: Data.playerStop
                canHover: true
                isClickable: true

                TapHandler {
                    onTapped: {
                        title.resetMarquee();
                        root.modelData.stop();
                    }
                }

                Component.onCompleted: {
                    Layout.preferredWidth = Layout.preferredWidth;
                    Layout.preferredHeight = Layout.preferredHeight;
                }
            }
            MenuCell {
                Layout.preferredWidth: root.buttonSize
                spacing: root.spacing
                text: Data.playerForwardIcon
                canHover: true
                isClickable: true

                Component.onCompleted: {
                    Layout.preferredWidth = Layout.preferredWidth;
                    Layout.preferredHeight = Layout.preferredHeight;
                }

                TapHandler {
                    onTapped: {
                        if (root.modelData.canGoNext) {
                            root.modelData.next();
                        }
                        title.resetMarquee();
                    }
                }
            }
        }
    }

    function formatSeconds(totalSeconds) {
        if (totalSeconds < 0)
            return "00:00";

        const pad = num => String(num).padStart(2, '0');

        const hours = Math.floor((totalSeconds % 86400) / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = Math.floor(totalSeconds % 60);

        const parts = [];
        if (hours > 0)
            parts.push(pad(hours));
        if (minutes > 0)
            parts.push(pad(minutes));
        else
            parts.push(pad(0));
        if (seconds > 0 || parts.length === 0)
            parts.push(pad(seconds));
        else
            parts.push(pad(0));

        return parts.join(':');
    }
}

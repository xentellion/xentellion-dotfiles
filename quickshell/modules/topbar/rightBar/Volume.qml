import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire

import "../../../config"
import "../../../components"

RowLayout {
    id: volumeTab
    readonly property var audioProps: Pipewire.defaultAudioSink?.audio
    readonly property int animationDuration: 200
    readonly property int sliderDuration: 2000

    property bool silentBoot: false // Used to hide slider on quickshell boot

    property bool sliderVisible: false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Button {
        id: volumeButton

        background: null
        checkable: true

        LabelWhite {
            id: label
            anchors.centerIn: volumeButton
            canHover: true

            text: {
                if (volumeTab.audioProps?.muted) {
                    return "";
                }
                return volumeTab.audioProps?.volume > 0.50 ? "" : "";
            }
        }

        TapHandler {
            id: lmb
            acceptedButtons: Qt.LeftButton
            onTapped: volumeTab.showSiderTemporarily()
        }

        TapHandler {
            id: rmb
            acceptedButtons: Qt.RightButton
            onTapped: switchMute.running = true
        }

        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }
    }

    Slider {
        id: volumeSlider
        Layout.preferredWidth: volumeTab.sliderVisible ? 120 : 0
        clip: true
        opacity: volumeTab.sliderVisible

        from: 0.0
        to: 1.0
        value: volumeTab.audioProps ? volumeTab.audioProps.volume : 0.0

        stepSize: 0.1
        snapMode: Slider.SnapAlways

        onValueChanged: {
            if (volumeTab.audioProps && pressed) {
                volumeTab.audioProps.volume = value;
            }
        }

        handle: Rectangle {
            x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
            implicitWidth: 5
            implicitHeight: 15
            radius: 1
            color: Theme.white
            border.color: Theme.textColor
        }

        background: Rectangle {
            x: volumeSlider.leftPadding
            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: volumeSlider.availableWidth
            height: implicitHeight
            radius: 2
            color: Theme.paleBackground

            Rectangle {
                width: volumeSlider.visualPosition * parent.width
                height: parent.height
                color: Theme.white
                radius: 2
            }
        }

        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: volumeTab.animationDuration
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: volumeTab.animationDuration
            }
        }
    }

    Connections {
        target: volumeTab.audioProps === undefined ? null : volumeTab.audioProps
        function onVolumeChanged() {
            if (!volumeTab.silentBoot) {
                volumeTab.silentBoot = true;
                return;
            }
            volumeTab.showSiderTemporarily();
        }
    }

    Timer {
        id: hideTimer
        interval: volumeTab.sliderDuration
        repeat: false
        onTriggered: {
            volumeTab.sliderVisible = false;
        }
    }

    Process {
        id: switchMute
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
    }

    function showSiderTemporarily() {
        volumeTab.sliderVisible = true;
        hideTimer.restart();
    }
}

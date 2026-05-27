import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Pipewire

import "../../effects"
import "../../data"

RowLayout {
    id: volumeTab
    readonly property var audioProps: Pipewire.defaultAudioSink?.audio
    readonly property int animationTime: 200
    property bool sliderVisible: false

    spacing: sliderVisible ? spacing : 0

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
                    return " ";
                }
                if (volumeTab.audioProps?.volume > 0.50) {
                    return " ";
                }
                return " ";
            }
        }

        TapHandler {
            id: lmb
            acceptedButtons: Qt.LeftButton
            onTapped: switchMute.running = true
        }

        TapHandler {
            id: rmb
            acceptedButtons: Qt.RightButton
            onTapped: volumeTab.sliderVisible = !volumeTab.sliderVisible
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

        handle: null

        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: volumeTab.animationTime
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: volumeTab.animationTime
            }
        }
    }

    Process {
        id: switchMute
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
    }
}

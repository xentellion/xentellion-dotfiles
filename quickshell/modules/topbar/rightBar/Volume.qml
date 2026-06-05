import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../../../config"
import "../../../services"
import "../../../components"

RowLayout {
    id: volumeTab
    readonly property int animationDuration: 200
    readonly property int sliderDuration: 2000

    property bool silentBoot: false // Is used to hide slider on quickshell boot

    property bool sliderVisible: false

    Button {
        id: volumeButton

        background: null
        checkable: true

        LabelWhite {
            id: label
            anchors.centerIn: volumeButton
            canHover: true

            color: VolumeService.audioProps?.muted ? Theme.urgent : Theme.white

            text: {
                if (VolumeService.audioProps === undefined) {
                    return Data.volumeIcons[0];
                }
                if (VolumeService.audioProps?.muted) {
                    return Data.volumeMute;
                }
                return Data.volumeIcons[Math.floor(VolumeService.audioProps?.volume * Data.volumeIcons.length)];
            }
        }

        TapHandler {
            id: lmb
            acceptedButtons: Qt.LeftButton
            onTapped: {
                volumeTab.showSiderTemporarily();
            }
        }

        TapHandler {
            id: rmb
            acceptedButtons: Qt.RightButton
            onTapped: {
                VolumeService.switchMute.running = true;
            }
        }

        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }
    }

    StyleSlider {
        id: volumeSlider

        Layout.preferredWidth: volumeTab.sliderVisible ? 120 : 0
        clip: true

        opacity: volumeTab.sliderVisible

        from: 0.0
        to: 1.0
        value: VolumeService.audioProps ? VolumeService.audioProps?.volume : 0.0

        stepSize: 0.1
        snapMode: Slider.SnapAlways

        redCondition: {
            return VolumeService.audioProps === undefined ? false : VolumeService.audioProps.muted;
        }

        onValueChanged: {
            if (VolumeService.audioProps && pressed) {
                VolumeService.audioProps.volume = value;
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
        target: VolumeService.audioProps === undefined ? null : VolumeService.audioProps
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

    function showSiderTemporarily() {
        volumeTab.sliderVisible = true;
        hideTimer.restart();
    }
}

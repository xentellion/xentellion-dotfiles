import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire

import "../../../config"
import "../../../components"

Button {
    id: micro
    readonly property var audioProps: Pipewire.defaultAudioSource?.audio

    property bool isVisible: !audioProps?.muted

    background: null
    checkable: false
    visible: micro.isVisible

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource]
    }

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: {
            return "";
        }
        color: Theme.warning
    }
}

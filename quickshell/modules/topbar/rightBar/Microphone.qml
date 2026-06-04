import QtQuick
import QtQuick.Controls

import "../../../config"
import "../../../services"
import "../../../components"

Button {
    id: micro

    property bool isVisible: !VolumeService.audioPropsMicro?.muted

    background: null
    checkable: false
    visible: micro.isVisible

    LabelWhite {
        id: label
        canHover: true
        anchors.centerIn: parent
        text: {
            return Data.microhoneIcon;
        }
        color: Theme.warning
    }
}

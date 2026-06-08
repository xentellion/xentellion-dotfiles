pragma ComponentBehavior: Bound

import QtQuick

import "../../../config"
import "../../../components"

SideCell {
    id: root

    color: Theme.cellColor
    LabelWhite {
        anchors.centerIn: parent
        text: "TODO: Notifications"
    }
}

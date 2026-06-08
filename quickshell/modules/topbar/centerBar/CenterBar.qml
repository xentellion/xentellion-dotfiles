pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../../../components"

DefaultCell {
    id: root

    required property int spacing
    required property int maxWidth
    required property int maxHeight
    required property int rightX

    anchors {
        top: parent.top
    }

    width: centerBlocks.width + spacing * 2
    height: parent.height
    radius: Math.floor(height / 2)

    x: {
        let perfectHalf = Math.floor((maxWidth - root.width) / 2);
        let delta = (rightX - root.spacing) - (perfectHalf + root.width);
        return perfectHalf + Math.min(delta, 0);
    }

    RowLayout {
        id: centerBlocks
        anchors.centerIn: parent
        spacing: root.spacing

        Repeater {
            Layout.alignment: Qt.AlignCenter
            model: 10
            Workspace {
                defaultOpen: 5
                spacing: root.spacing
                barHeight: root.maxHeight
            }
        }
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../../../components"

RowLayout {
    id: root

    anchors {
        top: parent.top
        right: parent.right
    }
    height: parent.height

    Language {
        id: languageLayout
        spacing: root.spacing
        Layout.alignment: Qt.AlignRight
    }
    DefaultCell {
        id: dataBlock
        Layout.alignment: Qt.AlignRight
        Layout.preferredWidth: childrenRect.width + root.spacing * 4

        RowLayout {
            anchors.centerIn: parent
            spacing: root.spacing
            property int elementWidth: 20
            Idle {
                Layout.preferredWidth: parent.elementWidth
            }
            Wifi {
                Layout.preferredWidth: parent.elementWidth
            }
            Bluetooth {
                Layout.preferredWidth: parent.elementWidth
            }
            Volume {
                spacingMax: root.spacing
            }
            Microphone {
                Layout.preferredWidth: parent.elementWidth
            }
        }
    }
    Battery {
        id: battery
        spacing: root.spacing
        Layout.alignment: Qt.AlignRight
    }
    Clock {
        id: timePlate
        spacing: root.spacing
        Layout.alignment: Qt.AlignRight
    }
}

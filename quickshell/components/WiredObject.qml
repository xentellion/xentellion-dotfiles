import QtQuick
import QtQuick.Layouts

import "../config"
import "../services"

RowLayout {
    id: root
    required property var modelData

    visible: modelData.hasLink

    Item {
        Layout.minimumWidth: networkIcon.width
        LabelDark {
            id: networkIcon
            anchors.centerIn: parent
            isClickable: false
            text: Data.wired
            fontSize: 30
        }
    }
    ColumnLayout {
        id: wifiBlock

        Item {
            Layout.preferredHeight: wifiText.height
            Layout.preferredWidth: wifiText.width

            LabelDark {
                id: wifiText
                anchors.centerIn: parent
                isClickable: false
                text: "Ethernet"
            }
        }
        Item {
            Layout.preferredHeight: networkName.height
            Layout.preferredWidth: networkName.width

            LabelDark {
                id: networkName
                anchors.centerIn: parent
                isClickable: false
                fontSize: 12
                text: NetworkService.wiredDevices[0].linkSpeed
            }
        }
    }
}

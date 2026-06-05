import QtQuick
import QtQuick.Layouts

import "../services"

RowLayout {
    id: root
    required property var modelData
    visible: {
        return modelData.state != 0;
    }

    Item {
        Layout.minimumWidth: networkIcon.width
        LabelDark {
            id: networkIcon
            anchors.centerIn: parent
            isClickable: false
            text: NetworkService.getWifiStrength(root.modelData)
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
                text: "Wi-Fi"
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
                text: NetworkService.getNetworkName(root.modelData)
            }
        }
    }
}

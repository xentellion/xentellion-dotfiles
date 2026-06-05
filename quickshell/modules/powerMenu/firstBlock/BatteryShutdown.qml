import QtQuick
import QtQuick.Layouts

import "../../../services"
import "../../../components"

RowLayout {
    id: root
    Layout.preferredHeight: childrenRect.height

    MenuCell {
        spacing: root.spacing

        text: {
            let result = `${BatteryService.icon} `;
            switch (BatteryService.battery.state) {
            case 1:
                result += BatteryService.timeToFull;
                break;
            case 2:
                result += BatteryService.timeToEmpty;
                break;
            case 3:
                result += "Battery empty";
                break;
            case 4:
                result += "Battery full";
                break;
            case 5:
                result += "Connected";
                break;
            case 6:
                result += "Disconnected";
                break;
            default:
                result += "Processing";
                break;
            }
            return result;
        }
    }
    Item {
        Layout.fillWidth: true
    }
    MenuCell {
        id: rebootButton
        spacing: root.spacing
        isSquare: true
        isClickable: true
        text: ""

        TapHandler {
            onTapped: {
                BatteryService.reboot.running = true;
            }
        }
    }
    MenuCell {
        id: shutdownButton
        spacing: root.spacing
        isSquare: true
        isClickable: true
        text: ""

        TapHandler {
            onTapped: {
                BatteryService.shutdown.running = true;
            }
        }
    }
}

import QtQuick
import Quickshell

import "modules/topbar"
import "modules/notifications"
import "modules/powerMenu"
import "config"
import "services"

ShellRoot {
    id: root

    TopBar {}
    PowerMenu {}

    KeyBinds {}

    Item {
        property var connection: Connections {
            target: NotificationService.notify

            function onNotification(n) {
                n.tracked = true;
                console.log(n.summary);
            }
        }
    }

    NotificationPlato {}
}

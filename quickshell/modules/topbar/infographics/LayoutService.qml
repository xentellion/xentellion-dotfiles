pragma Singleton

import QtQuick
import Quickshell.Hyprland

QtObject {
    id: layoutService

    property string currentLayout: "EN"

    function parseLayout(fullLayoutName) {
        if (!fullLayoutName)
            return;

        const shortName = fullLayoutName.substring(0, 2).toUpperCase();

        if (currentLayout !== shortName) {
            currentLayout = shortName;
        }
    }

    function handleRawEvent(event) {
        if (event.name === "activelayout") {
            const dataString = event.data;
            const layoutInfo = dataString.split(",");
            const fullLayoutName = layoutInfo[layoutInfo.length - 1];

            parseLayout(fullLayoutName);
        }
    }

    Component.onCompleted: {
        Hyprland.rawEvent.connect(handleRawEvent);
    }
}

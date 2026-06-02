pragma Singleton

import QtQuick
import Quickshell.Hyprland

import "../config"

QtObject {
    id: titleService

    property string text: Data.getQuote()
    property int maxLength: 30

    function parseLayout(fullLayoutName) {
        if (fullLayoutName === "") {
            text = Data.getQuote();
            return;
        }
        text = (fullLayoutName.length > maxLength) ? fullLayoutName.slice(0, maxLength - 1) + '...' : fullLayoutName;
    }

    function handleRawEvent(event) {
        if (event.name === "activewindow") {
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

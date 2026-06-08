import QtQuick
import QtQuick.Controls

import "../../../config"
import "../../../components"

Button {
    id: menu
    property int colorChangeDuration: 200
    property bool runAnimation: false
    // width: logo.width

    background: null

    Image {
        id: logo
        anchors.centerIn: parent
        source: Qt.resolvedUrl("../../../assets/icons/arch.png")
        fillMode: Image.Stretch
        visible: !hoverHandler.hovered
    }

    TextLight {
        id: logoShadow
        scale: 1
        source: logo
        anchors.fill: logo
        shadowEnabled: hoverHandler.hovered
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: lmb
        acceptedButtons: Qt.LeftButton
        onTapped: {
            States.menuOpen = !States.menuOpen;
            menu.runAnimation = !menu.runAnimation;
        }
    }

    Behavior on runAnimation {
        SequentialAnimation {
            NumberAnimation {
                target: logoShadow
                properties: "scale"
                to: 0.6
                duration: menu.colorChangeDuration / 2
            }
            NumberAnimation {
                target: logoShadow
                properties: "scale"
                to: 1
                duration: menu.colorChangeDuration / 2
            }
        }
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../config"

Rectangle {
    id: root
    required property int spacing
    required property string text
    property bool isSquare: false
    property bool canHover: true
    property bool isClickable: false

    Layout.preferredHeight: childrenRect.height
    Layout.preferredWidth: isSquare ? childrenRect.height : childrenRect.width + spacing * 2

    radius: height > 20 ? 10 : height / 2

    color: Theme.white

    LabelDark {
        anchors.centerIn: parent
        isClickable: root.isClickable
        text: root.text
    }

    HoverHandler {
        id: hover
    }

    layer.enabled: canHover ? hover.hovered : false
    layer.effect: TextLight {
        source: root
    }
}

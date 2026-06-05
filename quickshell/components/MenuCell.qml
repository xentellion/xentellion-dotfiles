pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import "../config"

Rectangle {
    id: root
    required property int spacing
    property string text: ""
    property bool isSquare: false
    property bool canHover: true
    property bool isClickable: false
    property var textColor: Theme.textColor

    property alias fontWeightDark: textObject.fontSize

    Layout.preferredHeight: childrenRect.height
    Layout.preferredWidth: isSquare ? textObject.implicitHeight : textObject.width + spacing * 2

    radius: height > 20 ? 10 : height / 2

    color: Theme.white

    LabelDark {
        id: textObject
        anchors.centerIn: parent
        isClickable: root.isClickable
        color: root.textColor
        text: root.text
        visible: text !== ""
    }

    HoverHandler {
        id: hover
        cursorShape: root.isClickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    layer.enabled: canHover ? hover.hovered : false
    layer.effect: TextLight {
        source: root
    }
}

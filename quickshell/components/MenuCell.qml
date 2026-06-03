import QtQuick
import QtQuick.Layouts

import "../config"

Rectangle {
    id: root
    required property int spacing
    required property string text
    property bool isSquare: false

    Layout.preferredHeight: childrenRect.height
    Layout.preferredWidth: isSquare ? childrenRect.height : childrenRect.width + spacing * 2

    radius: height > 20 ? 10 : height / 2

    color: Theme.white

    LabelDark {
        anchors.centerIn: parent
        text: root.text
    }
}

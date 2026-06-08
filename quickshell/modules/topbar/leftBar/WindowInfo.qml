import QtQuick

import "../../../components"
import "../../../services"

LabelWhite {
    id: root
    property string windowText: TitleService.text

    isClickable: false
    clip: true
    text: windowText
    elide: Text.ElideRight

    readonly property var textMetrics: TextMetrics {
        font.family: root.font.family
        font.pixelSize: root.font.weight
    }
}

pragma ComponentBehavior: Bound

import QtQuick

import "../data"

LabelWhite {
    id: label

    color: Theme.textColor
    layer.enabled: true
    layer.effect: TextShadow {
        source: label
    }
}

pragma ComponentBehavior: Bound

import QtQuick

import "../config"

LabelWhite {
    id: label

    color: Theme.textColor
    layer.enabled: true
    layer.effect: TextShadow {
        source: label
    }
}

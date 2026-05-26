import QtQuick
import "../theme"

Rectangle {
    id: root
    radius: 4

    property string text: ""
    property bool selected: false
    property bool compact: false
    property color accent: colors.copperBright
    signal activated()

    Colors { id: colors }
    Fonts { id: fonts }

    width: compact ? Math.max(52, label.implicitWidth + 20) : Math.max(64, label.implicitWidth + 28)
    height: compact ? 26 : 32
    color: selected ? Qt.rgba(accent.r, accent.g, accent.b, 0.24) : colors.panelGlass
    border.color: selected ? accent : colors.lineDim
    border.width: selected ? 2 : 1
    opacity: press.pressed ? 0.68 : 1.0

    Behavior on color { ColorAnimation { duration: 120 } }
    Behavior on opacity { NumberAnimation { duration: 80 } }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: root.selected ? colors.whiteSoft : colors.textSecondary
        font.family: fonts.mono
        font.pixelSize: root.compact ? fonts.micro : fonts.caption
        font.bold: root.selected
    }

    MouseArea {
        id: press
        anchors.fill: parent
        onClicked: root.activated()
    }
}

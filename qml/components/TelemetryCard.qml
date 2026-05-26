import QtQuick
import "../theme"

Item {
    id: root
    width: 150
    height: 68

    property string label: "LABEL"
    property string value: "--"
    property string unit: ""
    property color accent: colors.copperBright
    property bool dense: false

    Colors { id: colors }
    Fonts { id: fonts }

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: colors.panelGlass
        opacity: 0.52
        border.color: colors.lineDim
        border.width: 1
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2
        color: root.accent
        opacity: 0.7
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 10
        text: root.label
        color: colors.textSecondary
        font.family: fonts.mono
        font.pixelSize: fonts.micro
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        spacing: 4

        Text {
            text: root.value
            color: colors.textPrimary
            font.family: fonts.display
            font.pixelSize: root.dense ? 20 : fonts.value
            font.weight: Font.DemiBold
        }
        Text {
            y: parent.children[0].height - height - 3
            text: root.unit
            color: colors.textMuted
            font.family: fonts.mono
            font.pixelSize: fonts.caption
        }
    }
}

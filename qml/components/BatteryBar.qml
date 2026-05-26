import QtQuick
import "../theme"

Item {
    id: root
    width: 178
    height: 46

    property int value: 0
    property bool charging: false

    Colors { id: colors }
    Fonts { id: fonts }

    Rectangle {
        anchors.fill: parent
        color: "#00000000"
        border.color: colors.lineDim
        border.width: 1
        radius: 4
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: (parent.width - 50) * root.value / 100
        height: 8
        radius: 2
        color: root.value < 20 ? colors.red : (root.charging ? colors.green : colors.cyan)
        opacity: 0.82
        Behavior on width { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        text: root.value + "%"
        color: colors.textPrimary
        font.family: fonts.mono
        font.pixelSize: fonts.body
        font.bold: true
    }
}

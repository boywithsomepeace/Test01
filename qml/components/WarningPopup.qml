import QtQuick
import "../theme"

Item {
    id: root
    width: 260
    height: 58

    property bool active: false
    property string title: ""
    property string message: ""
    property string severity: "nominal"

    Colors { id: colors }
    Fonts { id: fonts }

    opacity: active ? 1.0 : 0.0
    y: active ? 0 : -12
    visible: opacity > 0.01

    Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: "#130908"
        border.width: 1
        border.color: root.severity === "critical" ? colors.red : colors.amber
        opacity: 0.94
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.top: parent.top
        anchors.topMargin: 9
        text: root.title
        color: root.severity === "critical" ? colors.red : colors.amber
        font.family: fonts.mono
        font.pixelSize: fonts.caption
        font.bold: true
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 9
        text: root.message
        color: colors.textPrimary
        elide: Text.ElideRight
        font.family: fonts.display
        font.pixelSize: fonts.caption
    }
}

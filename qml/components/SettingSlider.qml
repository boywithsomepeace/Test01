import QtQuick
import "../theme"

Item {
    id: root
    width: 280
    height: 38

    property string label: "VALUE"
    property real value: 0.5
    property real from: 0.0
    property real to: 1.0
    property color accent: colors.cyan
    signal valueEdited(real value)

    Colors { id: colors }
    Fonts { id: fonts }

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        text: root.label + " " + Math.round(root.value * 100) + "%"
        color: colors.textSecondary
        font.family: fonts.mono
        font.pixelSize: fonts.caption
    }

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        height: 4
        radius: 2
        color: colors.lineDim

        Rectangle {
            width: Math.max(0, Math.min(parent.width, parent.width * ((root.value - root.from) / (root.to - root.from))))
            height: parent.height
            radius: parent.radius
            color: root.accent
        }

        Rectangle {
            width: 14
            height: 14
            radius: 2
            color: colors.whiteSoft
            border.color: root.accent
            border.width: 1
            x: Math.max(0, Math.min(track.width - width, track.width * ((root.value - root.from) / (root.to - root.from)) - width / 2))
            y: -5
        }
    }

    MouseArea {
        anchors.fill: parent
        function setFromMouse(mouseX) {
            var n = Math.max(0, Math.min(1, mouseX / track.width))
            root.value = root.from + n * (root.to - root.from)
            root.valueEdited(root.value)
        }
        onPressed: function(mouse) { setFromMouse(mouse.x) }
        onPositionChanged: function(mouse) { if (pressed) setFromMouse(mouse.x) }
    }
}

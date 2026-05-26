import QtQuick
import "../theme"

Item {
    id: root
    width: 520
    height: 92

    property string avgText: "Avg. 11.3 u/km"
    property string odoText: "ODO. 6666.6 km"
    property string rangeText: "465km"
    property string gear: "N"
    property int batterySoc: 100
    property bool batteryCharging: false
    property color accent: colors.copperBright

    Colors { id: colors }
    Fonts { id: fonts }

    Canvas {
        id: railShape
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = 1
            ctx.strokeStyle = root.accent
            ctx.globalAlpha = 0.58

            var cx = width / 2
            ctx.beginPath()
            ctx.moveTo(2, 54)
            ctx.lineTo(118, 54)
            ctx.lineTo(144, 30)
            ctx.lineTo(cx - 58, 30)
            ctx.lineTo(cx - 30, 18)
            ctx.lineTo(cx + 30, 18)
            ctx.lineTo(cx + 58, 30)
            ctx.lineTo(width - 144, 30)
            ctx.lineTo(width - 118, 54)
            ctx.lineTo(width - 2, 54)
            ctx.stroke()

            ctx.globalAlpha = 0.35
            ctx.beginPath()
            ctx.moveTo(22, 80)
            ctx.lineTo(width - 22, 80)
            ctx.stroke()
        }
    }

    Text {
        x: 54
        y: 34
        text: root.avgText
        color: colors.textMuted
        font.family: fonts.mono
        font.pixelSize: fonts.caption
    }

    Text {
        x: root.width - width - 54
        y: 34
        text: root.odoText
        color: colors.textMuted
        font.family: fonts.mono
        font.pixelSize: fonts.caption
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 31
        spacing: 10
        Repeater {
            model: ["S", "D", "N", "P", "R"]
            delegate: Text {
                text: modelData.toLowerCase()
                color: modelData === root.gear.toUpperCase() ? root.accent : colors.textMuted
                opacity: modelData === root.gear.toUpperCase() ? 1 : 0.62
                font.family: fonts.display
                font.pixelSize: modelData === root.gear.toUpperCase() ? 36 : 11
                font.weight: modelData === root.gear.toUpperCase() ? Font.DemiBold : Font.Normal
                y: modelData === root.gear.toUpperCase() ? -15 : 4
                Behavior on opacity { NumberAnimation { duration: 180 } }
                Behavior on font.pixelSize { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 62
        spacing: 5
        Text {
            text: "Rest."
            color: colors.textMuted
            font.family: fonts.mono
            font.pixelSize: fonts.micro
        }
        Text {
            text: root.rangeText
            color: colors.green
            font.family: fonts.mono
            font.pixelSize: fonts.micro
            font.bold: true
        }
    }

    Row {
        id: batterySegments
        x: 76
        y: 78
        spacing: 3
        Repeater {
            model: 42
            delegate: Rectangle {
                width: 8
                height: 4
                color: index < Math.round(root.batterySoc * 42 / 100)
                       ? (root.batterySoc < 20 ? colors.red : root.accent)
                       : colors.lineDim
                opacity: index < Math.round(root.batterySoc * 42 / 100) ? 0.78 : 0.55
                Behavior on color { ColorAnimation { duration: 180 } }
            }
        }
    }

    Text {
        x: 64
        y: 74
        text: "E"
        color: colors.textMuted
        font.family: fonts.mono
        font.pixelSize: fonts.micro
    }

    Text {
        anchors.left: batterySegments.right
        anchors.leftMargin: 10
        y: 72
        text: root.batterySoc + "%"
        color: root.batterySoc < 20 ? colors.red : colors.green
        font.family: fonts.mono
        font.pixelSize: fonts.micro
        font.bold: true
    }
}

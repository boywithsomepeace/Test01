import QtQuick
import "../theme"

Item {
    id: root
    width: 220
    height: 92

    property string label: "SIGNAL"
    property real value: 0
    property real minValue: 0
    property real maxValue: 100
    property color accent: colors.copperBright
    property var samples: []

    Colors { id: colors }
    Fonts { id: fonts }

    onValueChanged: {
        var next = samples.slice()
        next.push(Math.max(minValue, Math.min(maxValue, value)))
        while (next.length > 48)
            next.shift()
        samples = next
        graph.requestPaint()
    }

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: colors.panelGlass
        opacity: 0.48
        border.color: colors.lineDim
        border.width: 1
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 7
        text: root.label
        color: colors.textSecondary
        font.family: fonts.mono
        font.pixelSize: fonts.micro
    }

    Canvas {
        id: graph
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10
        anchors.topMargin: 24
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = colors.lineDim
            ctx.globalAlpha = 0.5
            ctx.lineWidth = 1
            for (var i = 1; i < 4; ++i) {
                var y = height * i / 4
                ctx.beginPath()
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
                ctx.stroke()
            }

            if (root.samples.length < 2)
                return

            ctx.globalAlpha = 0.95
            ctx.strokeStyle = root.accent
            ctx.lineWidth = 2
            ctx.beginPath()
            for (var j = 0; j < root.samples.length; ++j) {
                var x = width * j / 47
                var n = (root.samples[j] - root.minValue) / (root.maxValue - root.minValue)
                var py = height - Math.max(0, Math.min(1, n)) * height
                if (j === 0)
                    ctx.moveTo(x, py)
                else
                    ctx.lineTo(x, py)
            }
            ctx.stroke()
        }
    }
}

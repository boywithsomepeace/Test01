import QtQuick
import "../theme"

Item {
    id: root
    width: 220
    height: 260

    property bool mirrored: false
    property real intensity: 0.72

    Colors { id: colors }

    Canvas {
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = 2
            ctx.lineJoin = "miter"
            ctx.lineCap = "butt"

            var count = 12
            for (var i = 0; i < count; ++i) {
                var t = i / (count - 1)
                var alpha = root.intensity * (1.0 - t) * 0.48
                var inset = i * 11
                var x0 = root.mirrored ? width - inset : inset
                var x1 = root.mirrored ? width - 126 - inset * 0.32 : 126 + inset * 0.32
                var y0 = 28 + i * 3
                var ym = height * 0.48
                var y1 = height - 36 - i * 3

                ctx.strokeStyle = colors.copperBright
                ctx.globalAlpha = alpha
                ctx.beginPath()
                ctx.moveTo(x0, y0)
                ctx.lineTo(x1, ym)
                ctx.lineTo(x0, y1)
                ctx.stroke()
            }

            ctx.globalAlpha = 0.08
            ctx.strokeStyle = colors.copper
            ctx.lineWidth = 1
            for (var j = 0; j < 9; ++j) {
                var p = j / 8
                var bx = root.mirrored ? width - 10 - j * 18 : 10 + j * 18
                ctx.beginPath()
                ctx.moveTo(bx, height - 20)
                ctx.lineTo(root.mirrored ? width - 160 - p * 18 : 160 + p * 18, height * 0.52)
                ctx.stroke()
            }
        }
    }
}

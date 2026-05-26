import QtQuick
import "../theme"

Item {
    id: root
    width: 230
    height: 150

    property string driveMode: "ECO"
    property real throttle: 0
    property real pwm: 0

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

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "PWM MAP " + root.driveMode
        color: colors.textSecondary
        font.family: fonts.mono
        font.pixelSize: fonts.caption
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 10
        text: Math.round(root.throttle) + "% -> " + Math.round(root.pwm) + "%"
        color: colors.textMuted
        font.family: fonts.mono
        font.pixelSize: fonts.micro
    }

    Canvas {
        id: curve
        anchors.fill: parent
        anchors.margins: 18
        anchors.topMargin: 34
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineWidth = 1
            ctx.strokeStyle = colors.lineDim
            ctx.globalAlpha = 0.6
            ctx.strokeRect(0, 0, width, height)

            function map(mode, t) {
                if (mode === "SPORTS")
                    return Math.pow(t, 0.62)
                if (mode === "CITY")
                    return t
                return Math.log(1 + 8 * t) / Math.log(9) * 0.72
            }

            var accent = root.driveMode === "SPORTS" ? colors.red
                       : root.driveMode === "CITY" ? colors.cyan
                       : colors.green
            ctx.strokeStyle = accent
            ctx.globalAlpha = 0.95
            ctx.lineWidth = 2
            ctx.beginPath()
            for (var i = 0; i <= 80; ++i) {
                var t = i / 80
                var x = t * width
                var y = height - map(root.driveMode, t) * height
                if (i === 0)
                    ctx.moveTo(x, y)
                else
                    ctx.lineTo(x, y)
            }
            ctx.stroke()

            var tx = Math.max(0, Math.min(1, root.throttle / 100)) * width
            var py = height - Math.max(0, Math.min(1, root.pwm / 100)) * height
            ctx.fillStyle = colors.whiteSoft
            ctx.globalAlpha = 1
            ctx.beginPath()
            ctx.arc(tx, py, 4, 0, Math.PI * 2)
            ctx.fill()
        }
    }

    Connections {
        target: root
        function onDriveModeChanged() { curve.requestPaint() }
        function onThrottleChanged() { curve.requestPaint() }
        function onPwmChanged() { curve.requestPaint() }
    }
}

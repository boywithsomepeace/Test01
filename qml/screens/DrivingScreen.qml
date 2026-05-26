import QtQuick
import QtQuick.Controls
import "../components"
import "../theme"

Item {
    id: root
    width: 800
    height: 480

    property var vehicle
    property var warnings
    property bool metricUnits: true
    property string language: "eng"
    property string themeName: "copper"
    property string driveMode: "ECO"
    property real brightness: 0.82
    property real contrast: 0.5
    readonly property color accentColor: themeName === "ice" ? colors.cyan
                                       : themeName === "ember" ? colors.amber
                                       : colors.copperBright
    signal debugRequested()
    signal settingsRequested()

    Colors { id: colors }
    Fonts { id: fonts }

    Rectangle {
        anchors.fill: parent
        color: colors.voidBlack
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 22
        text: root.language === "ger" ? "Elektroauto Dashboard"
              : root.language === "esp" ? "Panel Vehiculo Electrico"
              : "Electric Car Dashboard"
        color: root.accentColor
        font.family: fonts.display
        font.pixelSize: 38
        font.weight: Font.DemiBold
        opacity: 0.88
        visible: parent.height >= 470
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 78
        anchors.top: parent.top
        anchors.topMargin: 24
        text: "EV"
        color: root.accentColor
        font.family: fonts.mono
        font.pixelSize: 26
        font.bold: true
        opacity: 0.72
        visible: parent.height >= 470
    }

    Rectangle {
        id: cockpit
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: parent.height >= 470 ? 116 : 0
        anchors.bottomMargin: parent.height >= 470 ? 28 : 0
        color: colors.voidBlack
    }

    Canvas {
        id: shell
        anchors.fill: cockpit
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.lineJoin = "miter"

            function sx(v) { return v * width / 768 }
            function sy(v) { return v * height / 320 }

            var pts = [
                [8, 156], [112, 28], [238, 10], [298, 50],
                [470, 50], [530, 10], [656, 28], [760, 156],
                [672, 304], [96, 304]
            ]

            ctx.strokeStyle = root.accentColor
            ctx.globalAlpha = 0.82
            ctx.lineWidth = 4
            ctx.beginPath()
            ctx.moveTo(sx(pts[0][0]), sy(pts[0][1]))
            for (var i = 1; i < pts.length; ++i)
                ctx.lineTo(sx(pts[i][0]), sy(pts[i][1]))
            ctx.closePath()
            ctx.stroke()

            ctx.globalAlpha = 0.18
            ctx.lineWidth = 1
            ctx.strokeStyle = root.accentColor
            ctx.stroke()

            ctx.globalAlpha = 0.35
            ctx.strokeStyle = colors.lineDim
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.moveTo(sx(150), sy(244))
            ctx.lineTo(sx(250), sy(220))
            ctx.lineTo(sx(306), sy(220))
            ctx.lineTo(sx(334), sy(205))
            ctx.lineTo(sx(434), sy(205))
            ctx.lineTo(sx(462), sy(220))
            ctx.lineTo(sx(518), sy(220))
            ctx.lineTo(sx(618), sy(244))
            ctx.stroke()

            ctx.globalAlpha = 0.18
            ctx.beginPath()
            ctx.moveTo(sx(92), sy(304))
            ctx.lineTo(sx(676), sy(304))
            ctx.stroke()
        }
    }

    Connections {
        target: root
        function onThemeNameChanged() { shell.requestPaint() }
    }

    ChevronTunnel {
        anchors.left: cockpit.left
        anchors.leftMargin: 160
        anchors.verticalCenter: cockpit.verticalCenter
        anchors.verticalCenterOffset: 8
        width: 196
        height: 238
    }

    ChevronTunnel {
        anchors.right: cockpit.right
        anchors.rightMargin: 160
        anchors.verticalCenter: cockpit.verticalCenter
        anchors.verticalCenterOffset: 8
        width: 196
        height: 238
        mirrored: true
    }

    TopStatusBar {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: cockpit.top
        anchors.topMargin: 20
        leftIndicator: root.vehicle ? root.vehicle.leftIndicator : false
        rightIndicator: root.vehicle ? root.vehicle.rightIndicator : false
        headlights: root.vehicle ? root.vehicle.headlights : false
        weatherText: {
            if (!root.vehicle)
                return "PUNE --"
            var temp = root.metricUnits ? root.vehicle.ambientTempC : (root.vehicle.ambientTempC * 9 / 5 + 32)
            return root.vehicle.weatherCondition + " " + Math.round(temp)
        }
    }

    WarningPopup {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: cockpit.top
        anchors.topMargin: 2
        active: root.warnings ? root.warnings.active : false
        title: root.warnings ? root.warnings.title : ""
        message: root.warnings ? root.warnings.message : ""
        severity: root.warnings ? root.warnings.severity : "nominal"
    }

    Speedometer {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: cockpit.top
        anchors.topMargin: 82
        speed: root.vehicle ? (root.metricUnits ? root.vehicle.speed : Math.round(root.vehicle.speed * 0.621371)) : 0
        rangeKm: root.vehicle ? (root.metricUnits ? root.vehicle.rangeKm : Math.round(root.vehicle.rangeKm * 0.621371)) : 0
        regenKw: root.vehicle ? root.vehicle.regenKw : 0
        limiterText: root.metricUnits ? "100 km/H" : "62 mph"
        speedUnit: root.metricUnits ? "km/h" : "mph"
    }

    BottomTelemetryRail {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: cockpit.bottom
        anchors.bottomMargin: 12
        width: 520
        avgText: root.vehicle
                 ? ("Avg. " + (root.metricUnits
                               ? root.vehicle.averageEfficiency.toFixed(1) + " u/km"
                               : (root.vehicle.averageEfficiency / 0.621371).toFixed(1) + " u/mi"))
                 : "Avg. --"
        odoText: root.vehicle
                 ? ("ODO. " + (root.metricUnits
                               ? root.vehicle.odometerKm.toFixed(1) + " km"
                               : (root.vehicle.odometerKm * 0.621371).toFixed(1) + " mi"))
                 : "ODO. --"
        rangeText: root.vehicle
                   ? ((root.metricUnits ? root.vehicle.rangeKm : Math.round(root.vehicle.rangeKm * 0.621371))
                      + (root.metricUnits ? "km" : "mi"))
                   : "--"
        gear: root.vehicle ? root.vehicle.gear : "N"
        batterySoc: root.vehicle ? root.vehicle.batterySoc : 100
        batteryCharging: root.vehicle ? root.vehicle.charging : false
        accent: root.accentColor
    }

    Rectangle {
        anchors.left: cockpit.left
        anchors.leftMargin: 70
        anchors.top: cockpit.top
        anchors.topMargin: 78
        width: 120
        height: 42
        radius: 4
        color: colors.panelGlass
        opacity: 0.62
        border.color: colors.lineDim
        border.width: 1

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 7
            text: "MODE"
            color: colors.textMuted
            font.family: fonts.mono
            font.pixelSize: fonts.micro
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7
            text: root.driveMode
            color: root.driveMode === "SPORTS" ? colors.red : (root.driveMode === "CITY" ? colors.cyan : colors.green)
            font.family: fonts.mono
            font.pixelSize: fonts.body
            font.bold: true
        }
    }

    Rectangle {
        anchors.right: cockpit.right
        anchors.rightMargin: 70
        anchors.top: cockpit.top
        anchors.topMargin: 78
        width: 120
        height: 42
        radius: 4
        color: colors.panelGlass
        opacity: 0.62
        border.color: colors.lineDim
        border.width: 1

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 7
            text: "PWM"
            color: colors.textMuted
            font.family: fonts.mono
            font.pixelSize: fonts.micro
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7
            text: root.vehicle ? root.vehicle.pwmCommand.toFixed(0) + "%" : "--"
            color: root.accentColor
            font.family: fonts.mono
            font.pixelSize: fonts.body
            font.bold: true
        }
    }

    SettingPill {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 14
        anchors.topMargin: 10
        text: "DBG"
        compact: true
        selected: false
        z: 40
        onActivated: root.debugRequested()
    }

    SettingPill {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 14
        anchors.topMargin: 10
        text: "SET"
        compact: true
        selected: false
        z: 40
        onActivated: root.settingsRequested()
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 1.0 - root.brightness
        z: 30
        visible: opacity > 0.01
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: Math.max(0, 0.5 - root.contrast) * 0.28
        z: 31
        visible: opacity > 0.01
    }
}

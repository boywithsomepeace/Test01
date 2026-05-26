import QtQuick
import "../components"
import "../theme"

Item {
    id: root
    width: 800
    height: 480

    property var vehicle
    property bool metricUnits: true
    property string driveMode: "ECO"
    property string themeName: "copper"
    readonly property color accentColor: themeName === "ice" ? colors.cyan
                                       : themeName === "ember" ? colors.amber
                                       : colors.copperBright
    signal backRequested()

    Colors { id: colors }
    Fonts { id: fonts }

    Rectangle { anchors.fill: parent; color: colors.voidBlack }

    Canvas {
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = root.accentColor
            ctx.globalAlpha = 0.34
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.moveTo(34, 58)
            ctx.lineTo(268, 58)
            ctx.lineTo(290, 42)
            ctx.lineTo(510, 42)
            ctx.lineTo(532, 58)
            ctx.lineTo(766, 58)
            ctx.stroke()
            ctx.globalAlpha = 0.16
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.moveTo(34, 416)
            ctx.lineTo(766, 416)
            ctx.stroke()
        }
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 34
        anchors.top: parent.top
        anchors.topMargin: 22
        text: "DIAGNOSTICS"
        color: colors.textPrimary
        font.family: fonts.mono
        font.pixelSize: 18
        font.bold: true
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 34
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 8

        Text {
            text: root.driveMode
            color: root.driveMode === "SPORTS" ? colors.red : (root.driveMode === "CITY" ? colors.cyan : colors.green)
            font.family: fonts.mono
            font.pixelSize: fonts.body
            font.bold: true
        }
        Text {
            text: "PWM " + (root.vehicle ? root.vehicle.pwmCommand.toFixed(0) : "--") + "%"
            color: colors.textSecondary
            font.family: fonts.mono
            font.pixelSize: fonts.body
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 58
        height: 1
        color: colors.lineDim
        opacity: 0.75
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 34
        anchors.top: parent.top
        anchors.topMargin: 78
        spacing: 10

        TelemetryCard {
            width: 118
            height: 58
            label: "SPEED"
            value: root.vehicle ? (root.metricUnits ? root.vehicle.speed : Math.round(root.vehicle.speed * 0.621371)) : "--"
            unit: root.metricUnits ? "km/h" : "mph"
            accent: root.accentColor
        }
        TelemetryCard {
            width: 118
            height: 58
            label: "THROTTLE"
            value: root.vehicle ? root.vehicle.throttlePercent.toFixed(0) : "--"
            unit: "%"
            accent: colors.green
        }
        TelemetryCard {
            width: 118
            height: 58
            label: "CURRENT"
            value: root.vehicle ? root.vehicle.packCurrent.toFixed(0) : "--"
            unit: "A"
            accent: colors.cyan
        }
        TelemetryCard {
            width: 118
            height: 58
            label: "SOC"
            value: root.vehicle ? root.vehicle.batterySoc : "--"
            unit: "%"
            accent: colors.green
        }
        TelemetryCard {
            width: 118
            height: 58
            label: "MOTOR"
            value: root.vehicle ? (root.metricUnits ? root.vehicle.motorTemp.toFixed(0) : (root.vehicle.motorTemp * 9 / 5 + 32).toFixed(0)) : "--"
            unit: root.metricUnits ? "C" : "F"
            accent: colors.amber
        }
        TelemetryCard {
            width: 118
            height: 58
            label: "INV"
            value: root.vehicle ? (root.metricUnits ? root.vehicle.inverterTemp.toFixed(0) : (root.vehicle.inverterTemp * 9 / 5 + 32).toFixed(0)) : "--"
            unit: root.metricUnits ? "C" : "F"
            accent: colors.copperBright
        }
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 34
        anchors.top: parent.top
        anchors.topMargin: 158
        spacing: 12

        Column {
            spacing: 12
            TelemetryGraph {
                width: 250
                height: 96
                label: "SPEED TRACE"
                value: root.vehicle ? root.vehicle.speed : 0
                maxValue: 140
                accent: root.accentColor
            }
            TelemetryGraph {
                width: 250
                height: 96
                label: "BATTERY CURRENT"
                value: root.vehicle ? root.vehicle.packCurrent : 0
                maxValue: 140
                accent: colors.cyan
            }
        }

        Column {
            spacing: 12
            TelemetryGraph {
                width: 250
                height: 96
                label: "PWM COMMAND"
                value: root.vehicle ? root.vehicle.pwmCommand : 0
                maxValue: 100
                accent: root.driveMode === "SPORTS" ? colors.red : (root.driveMode === "CITY" ? colors.cyan : colors.green)
            }
            TelemetryGraph {
                width: 250
                height: 96
                label: "DRIVETRAIN TEMP"
                value: root.vehicle ? root.vehicle.motorTemp : 0
                maxValue: 110
                accent: colors.amber
            }
        }

        ModeCurve {
            width: 202
            height: 204
            driveMode: root.driveMode
            throttle: root.vehicle ? root.vehicle.throttlePercent : 0
            pwm: root.vehicle ? root.vehicle.pwmCommand : 0
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 34
        anchors.right: parent.right
        anchors.rightMargin: 34
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 66
        height: 42
        radius: 4
        color: colors.panelGlass
        opacity: 0.5
        border.color: colors.lineDim
        border.width: 1

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: "MODE CURVE: " + (root.driveMode === "SPORTS" ? "SPORTS raises low pedal input for aggressive launch"
                                    : root.driveMode === "CITY" ? "CITY keeps PWM linear for predictable traffic control"
                                    : "ECO compresses PWM with a logarithmic efficiency cap")
            color: colors.textSecondary
            font.family: fonts.mono
            font.pixelSize: fonts.caption
            elide: Text.ElideRight
        }
    }

    SettingPill {
        anchors.left: parent.left
        anchors.leftMargin: 34
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 22
        text: "BACK"
        selected: true
        accent: root.accentColor
        onActivated: root.backRequested()
    }
}

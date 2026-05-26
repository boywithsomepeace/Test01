import QtQuick
import "../components"
import "../theme"

Item {
    id: root
    width: 800
    height: 480

    signal backRequested()
    property bool metricUnits: true
    property bool simulatorRunning: true
    property string language: "eng"
    property string themeName: "copper"
    property string driveMode: "ECO"
    property real brightness: 0.82
    property real contrast: 0.5
    readonly property color accentColor: themeName === "ice" ? colors.cyan
                                       : themeName === "ember" ? colors.amber
                                       : colors.copperBright
    signal unitsSelected(bool metric)
    signal simulatorSelected(bool running)
    signal languageSelected(string language)
    signal themeSelected(string themeName)
    signal driveModeSelected(string driveMode)
    signal brightnessSelected(real value)
    signal contrastSelected(real value)

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
            ctx.globalAlpha = 0.42
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.moveTo(34, 64)
            ctx.lineTo(210, 64)
            ctx.lineTo(232, 46)
            ctx.lineTo(568, 46)
            ctx.lineTo(590, 64)
            ctx.lineTo(766, 64)
            ctx.stroke()

            ctx.globalAlpha = 0.22
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.moveTo(34, 414)
            ctx.lineTo(766, 414)
            ctx.stroke()
        }
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 36
        anchors.top: parent.top
        anchors.topMargin: 26
        text: "SYSTEM SETTINGS"
        color: colors.textPrimary
        font.family: fonts.mono
        font.pixelSize: 18
        font.bold: true
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 38
        anchors.top: parent.top
        anchors.topMargin: 25
        spacing: 14

        Text {
            text: root.driveMode
            color: root.driveMode === "SPORTS" ? colors.red : (root.driveMode === "CITY" ? colors.cyan : colors.green)
            font.family: fonts.mono
            font.pixelSize: fonts.caption
            font.bold: true
        }
        Text {
            text: root.metricUnits ? "KM/C" : "MI/F"
            color: colors.textSecondary
            font.family: fonts.mono
            font.pixelSize: fonts.caption
        }
        Text {
            text: root.language.toUpperCase()
            color: colors.textSecondary
            font.family: fonts.mono
            font.pixelSize: fonts.caption
        }
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 36
        anchors.top: parent.top
        anchors.topMargin: 88
        spacing: 14

        Rectangle {
            width: 226
            height: 292
            radius: 4
            color: colors.panelGlass
            opacity: 0.62
            border.color: colors.lineDim
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 13

                Text { text: "REGION"; color: colors.textSecondary; font.family: fonts.mono; font.pixelSize: fonts.caption }
                Row {
                    spacing: 8
                    SettingPill { text: "KM / C"; compact: true; selected: root.metricUnits; accent: root.accentColor; onActivated: root.unitsSelected(true) }
                    SettingPill { text: "MI / F"; compact: true; selected: !root.metricUnits; accent: root.accentColor; onActivated: root.unitsSelected(false) }
                }

                Text { text: "LANGUAGE"; color: colors.textSecondary; font.family: fonts.mono; font.pixelSize: fonts.caption }
                Row {
                    spacing: 8
                    SettingPill { text: "ENG"; compact: true; selected: root.language === "eng"; accent: root.accentColor; onActivated: root.languageSelected("eng") }
                    SettingPill { text: "GER"; compact: true; selected: root.language === "ger"; accent: root.accentColor; onActivated: root.languageSelected("ger") }
                    SettingPill { text: "ESP"; compact: true; selected: root.language === "esp"; accent: root.accentColor; onActivated: root.languageSelected("esp") }
                }

                Rectangle { width: parent.width; height: 1; color: colors.lineDim; opacity: 0.8 }

                Text { text: "DRIVE MODE"; color: colors.textSecondary; font.family: fonts.mono; font.pixelSize: fonts.caption }
                Column {
                    spacing: 8
                    SettingPill { width: 142; text: "ECO"; selected: root.driveMode === "ECO"; accent: colors.green; onActivated: root.driveModeSelected("ECO") }
                    SettingPill { width: 142; text: "SPORTS"; selected: root.driveMode === "SPORTS"; accent: colors.red; onActivated: root.driveModeSelected("SPORTS") }
                    SettingPill { width: 142; text: "CITY"; selected: root.driveMode === "CITY"; accent: colors.cyan; onActivated: root.driveModeSelected("CITY") }
                }
            }
        }

        Rectangle {
            width: 250
            height: 292
            radius: 4
            color: colors.panelGlass
            opacity: 0.62
            border.color: colors.lineDim
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 13

                Text { text: "DISPLAY PROFILE"; color: colors.textSecondary; font.family: fonts.mono; font.pixelSize: fonts.caption }
                Row {
                    spacing: 8
                    SettingPill { text: "COPPER"; compact: true; selected: root.themeName === "copper"; accent: colors.copperBright; onActivated: root.themeSelected("copper") }
                    SettingPill { text: "ICE"; compact: true; selected: root.themeName === "ice"; accent: colors.cyan; onActivated: root.themeSelected("ice") }
                    SettingPill { text: "EMBER"; compact: true; selected: root.themeName === "ember"; accent: colors.amber; onActivated: root.themeSelected("ember") }
                }

                SettingSlider {
                    label: "BRIGHTNESS"
                    width: parent.width
                    value: root.brightness
                    from: 0.35
                    to: 1.0
                    accent: root.accentColor
                    onValueEdited: function(v) {
                        root.brightness = v
                        root.brightnessSelected(v)
                    }
                }

                SettingSlider {
                    label: "CONTRAST"
                    width: parent.width
                    value: root.contrast
                    from: 0.2
                    to: 1.0
                    accent: root.accentColor
                    onValueEdited: function(v) {
                        root.contrast = v
                        root.contrastSelected(v)
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 82
                    radius: 4
                    color: colors.voidBlack
                    border.color: root.accentColor
                    border.width: 1
                    opacity: 0.9

                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        width: 78
                        height: 8
                        radius: 2
                        color: colors.lineDim

                        Rectangle {
                            width: parent.width * root.brightness
                            height: parent.height
                            radius: parent.radius
                            color: root.accentColor
                        }
                    }
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        text: Math.round(root.brightness * 100) + " / " + Math.round(root.contrast * 100)
                        color: colors.textPrimary
                        font.family: fonts.mono
                        font.pixelSize: fonts.body
                        font.bold: true
                    }
                }
            }
        }

        Rectangle {
            width: 238
            height: 292
            radius: 4
            color: colors.panelGlass
            opacity: 0.62
            border.color: colors.lineDim
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 13

                Text { text: "SYSTEM STATE"; color: colors.textSecondary; font.family: fonts.mono; font.pixelSize: fonts.caption }
                SettingPill {
                    text: root.simulatorRunning ? "SIMULATOR ONLINE" : "SIMULATOR PAUSED"
                    selected: root.simulatorRunning
                    accent: root.simulatorRunning ? colors.green : colors.amber
                    onActivated: root.simulatorSelected(!root.simulatorRunning)
                }

                ModeCurve {
                    width: parent.width
                    height: 150
                    driveMode: root.driveMode
                    throttle: root.driveMode === "SPORTS" ? 74 : (root.driveMode === "CITY" ? 54 : 42)
                    pwm: root.driveMode === "SPORTS" ? 83 : (root.driveMode === "CITY" ? 54 : 50)
                }

                Text {
                    width: parent.width
                    text: root.driveMode === "SPORTS" ? "Sharp pedal map for peak response"
                          : root.driveMode === "CITY" ? "Linear map for traffic precision"
                          : "Limited logarithmic map for range"
                    color: colors.textSecondary
                    font.family: fonts.mono
                    font.pixelSize: fonts.micro
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 36
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        spacing: 12

        SettingPill {
            text: "BACK"
            selected: true
            accent: root.accentColor
            onActivated: root.backRequested()
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "Settings update live; no save step required"
            color: colors.textMuted
            font.family: fonts.mono
            font.pixelSize: fonts.micro
        }
    }
}

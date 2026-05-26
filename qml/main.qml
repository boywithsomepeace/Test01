import QtQuick
import QtQuick.Controls
import "screens"
import "theme"

ApplicationWindow {
    id: window
    width: 800
    height: 480
    visible: true
    color: colors.voidBlack
    title: "EV HMI"

    Colors { id: colors }
    Fonts { id: fonts }

    QtObject {
        id: state
        property bool metricUnits: true
        property bool simulatorRunning: true
        property string language: "eng"
        property string themeName: "copper"
        property string driveMode: "ECO"
        property real brightness: 0.82
        property real contrast: 0.5
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: driveScreen
    }

    Component {
        id: driveScreen
        DrivingScreen {
            vehicle: vehicleData
            warnings: warningManager
            metricUnits: state.metricUnits
            language: state.language
            themeName: state.themeName
            driveMode: state.driveMode
            brightness: state.brightness
            contrast: state.contrast
            onDebugRequested: stack.replace(debugScreen)
            onSettingsRequested: stack.replace(settingsScreen)
        }
    }

    Component {
        id: debugScreen
        DebugScreen {
            vehicle: vehicleData
            metricUnits: state.metricUnits
            driveMode: state.driveMode
            themeName: state.themeName
            onBackRequested: stack.replace(driveScreen)
        }
    }

    Component {
        id: settingsScreen
        SettingsScreen {
            metricUnits: state.metricUnits
            simulatorRunning: state.simulatorRunning
            language: state.language
            themeName: state.themeName
            driveMode: state.driveMode
            brightness: state.brightness
            contrast: state.contrast
            onUnitsSelected: function(metric) { state.metricUnits = metric }
            onSimulatorSelected: function(running) {
                state.simulatorRunning = running
                telemetrySimulator.setRunning(running)
            }
            onLanguageSelected: function(language) { state.language = language }
            onThemeSelected: function(themeName) { state.themeName = themeName }
            onDriveModeSelected: function(driveMode) {
                state.driveMode = driveMode
                vehicleData.driveMode = driveMode
            }
            onBrightnessSelected: function(value) { state.brightness = value }
            onContrastSelected: function(value) { state.contrast = value }
            onBackRequested: stack.replace(driveScreen)
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0
        SequentialAnimation on opacity {
            running: true
            NumberAnimation { from: 0.8; to: 0.0; duration: 520; easing.type: Easing.OutCubic }
        }
    }
}

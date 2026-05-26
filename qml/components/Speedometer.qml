import QtQuick
import "../theme"

Item {
    id: root
    width: 280
    height: 190

    property int speed: 0
    property int maxSpeed: 180
    property int rangeKm: 0
    property real regenKw: 0
    property string limiterText: "100 km/H"
    property string speedUnit: "km/h"

    Colors { id: colors }
    Fonts { id: fonts }

    property real shownSpeed: speed
    Behavior on shownSpeed {
        NumberAnimation { duration: 360; easing.type: Easing.OutCubic }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 42
        text: Math.round(root.shownSpeed).toString().padStart(2, "0")
        color: colors.whiteSoft
        font.family: fonts.display
        font.pixelSize: fonts.speed
        font.weight: Font.DemiBold
        style: Text.Raised
        styleColor: "#4c5056"
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 120
        text: root.speedUnit
        color: colors.textSecondary
        font.family: fonts.display
        font.pixelSize: fonts.caption
        opacity: 0.72
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 149
        spacing: 6
        Text { text: "◴"; color: colors.copperBright; font.pixelSize: 13 }
        Text {
            text: root.limiterText
            color: colors.copperBright
            font.family: fonts.mono
            font.pixelSize: fonts.caption
        }
    }
}

import QtQuick
import "../theme"

Row {
    id: root
    spacing: 12
    property string gear: "D"

    Colors { id: colors }
    Fonts { id: fonts }

    Repeater {
        model: ["P", "R", "N", "D"]
        delegate: Text {
            text: modelData
            color: root.gear === modelData ? colors.textPrimary : colors.textMuted
            opacity: root.gear === modelData ? 1.0 : 0.55
            font.family: fonts.mono
            font.pixelSize: root.gear === modelData ? 20 : 14
            font.bold: root.gear === modelData
            Behavior on opacity { NumberAnimation { duration: 160 } }
            Behavior on font.pixelSize { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        }
    }
}

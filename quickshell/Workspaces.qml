import Quickshell.Hyprland
import QtQuick

Row {
    spacing: 6

    Repeater {
        model: 5
        
        Rectangle {
            required property int index
            property int wsId: index + 1
            property bool focused: Hyprland.focusedWorkspace?.id === wsId
            property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

            width: focused ? 28 : 12
            height: 12
            radius: 6
            color: focused ? "#cba6f7" : occupied ? "#86b4fa" : "#45475a"

            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 200 } }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + parent.wsId)
            }
        }
    }
}

import Quickshell.Hyprland
import QtQuick

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: 16

    // Siempre muestra al menos 5; crece (hasta 10) si usas workspaces mayores.
    readonly property int count: Math.min(10, Math.max(5, ...Hyprland.workspaces.values.map(w => w.id)))

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: wheel => Hyprland.dispatch(wheel.angleDelta.y > 0 ? "workspace r-1" : "workspace r+1")
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Repeater {
            model: root.count

            Rectangle {
                id: dot
                required property int index
                readonly property int wsId: index + 1
                readonly property var ws: Hyprland.workspaces.values.find(w => w.id === wsId) ?? null
                readonly property bool focused: Hyprland.focusedWorkspace?.id === wsId
                readonly property bool occupied: (ws?.toplevels?.values?.length ?? 0) > 0
                readonly property bool urgent: ws?.urgent ?? false

                anchors.verticalCenter: parent.verticalCenter
                width: focused ? 26 : 10
                height: 10
                radius: 5
                color: urgent ? Theme.red
                     : focused ? Theme.mauve
                     : hover.containsMouse ? Theme.subtext0
                     : occupied ? Theme.blue
                     : Theme.surface2

                Behavior on width { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: Theme.anim } }

                MouseArea {
                    id: hover
                    anchors.fill: parent
                    anchors.margins: -3
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + dot.wsId)
                }
            }
        }
    }
}

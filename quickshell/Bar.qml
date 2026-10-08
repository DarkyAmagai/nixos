import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: 44
    color: "transparent"
    WlrLayershell.namespace: "quickshell-bar"

    Rectangle {
        id: frame
        anchors.fill: parent
        anchors { topMargin: 8; leftMargin: 10; rightMargin: 10 }
        radius: height / 2
        color: Theme.barBg
        border.color: Theme.border
        border.width: 1

        RowLayout {
            id: leftGroup
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            LauncherButton {}
            Pill { Workspaces {} }
        }

        WindowTitle {
            anchors.centerIn: parent
            maxWidth: Math.max(0, frame.width - 2 * Math.max(leftGroup.width, rightGroup.width) - 60)
        }

        RowLayout {
            id: rightGroup
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Pill {
                visible: tray.hasItems
                Tray { id: tray; parentWindow: bar }
            }
            Pill {
                Volume {}
                Battery {}
            }
            Pill {
                Clock { onClicked: calendar.visible = !calendar.visible }
            }
            PowerButton {}
        }
    }

    CalendarPopup {
        id: calendar
        screen: bar.screen
    }
}

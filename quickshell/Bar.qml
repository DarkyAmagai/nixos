import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: 46
    color: "transparent"
    WlrLayershell.namespace: "quickshell-bar"

    // Panel abierto ("", "calendar" o "control") y su alineación a la derecha.
    property string popup: ""
    property real popupRight: 10

    function togglePopup(name, item) {
        if (popup === name) { popup = ""; return; }
        popupRight = Math.max(10, bar.width - item.mapToItem(null, item.width, 0).x);
        popup = name;
    }

    Rectangle {
        id: frame
        anchors.fill: parent
        anchors { topMargin: 8; leftMargin: 10; rightMargin: 10 }
        radius: height / 2
        color: Theme.barBg
        border.color: Theme.glassEdge
        border.width: 1
        GlassSheen {}


        RowLayout {
            id: leftGroup
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            LauncherButton {}
            Pill { Workspaces {} }
            Pill {
                visible: media.has
                MediaPlayer { id: media }
            }
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
            spacing: 6

            Pill { SysMonitor {} }

            Pill {
                visible: tray.hasItems
                Tray { id: tray; parentWindow: bar }
            }

            // Píldora del sistema: red + volumen + batería -> abre el centro de control.
            Pill {
                id: sysPill
                interactive: true
                active: bar.popup === "control"
                spacing: 10
                onClicked: bar.togglePopup("control", sysPill)
                Network { active: sysPill.active }
                Volume { active: sysPill.active }
                Battery { visible: present; active: sysPill.active }
            }

            Pill {
                id: clockPill
                interactive: true
                active: bar.popup === "calendar"
                onClicked: bar.togglePopup("calendar", clockPill)
                Clock { active: clockPill.active }
            }
            PowerButton {}
        }
    }

    CalendarPopup {
        screen: bar.screen
        barWindow: bar
        open: bar.popup === "calendar"
        rightOffset: bar.popupRight
        onDismissed: bar.popup = ""
        WlrLayershell.namespace: "quickshell-calendar"
    }

    ControlCenter {
        screen: bar.screen
        barWindow: bar
        open: bar.popup === "control"
        rightOffset: bar.popupRight
        onDismissed: bar.popup = ""
        WlrLayershell.namespace: "quickshell-control"
    }
}

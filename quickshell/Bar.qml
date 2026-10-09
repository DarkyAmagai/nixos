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

    // Panel abierto en esta pantalla ("", "calendar" o "battery") y su alineación.
    property string popup: ""
    property real popupRight: 10

    function togglePopup(name, item) {
        if (popup === name) {
            popup = "";
            return;
        }
        popupRight = Math.max(10, bar.width - item.mapToItem(null, item.width, 0).x);
        popup = name;
    }

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
            spacing: 6

            Pill {
                visible: tray.hasItems
                Tray { id: tray; parentWindow: bar }
            }
            Pill { Volume {} }
            Pill {
                id: batteryPill
                visible: battery.present
                interactive: true
                active: bar.popup === "battery"
                onClicked: bar.togglePopup("battery", batteryPill)
                Battery { id: battery; active: batteryPill.active }
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

    BatteryPopup {
        screen: bar.screen
        barWindow: bar
        open: bar.popup === "battery"
        rightOffset: bar.popupRight
        onDismissed: bar.popup = ""
        WlrLayershell.namespace: "quickshell-battery"
    }
}

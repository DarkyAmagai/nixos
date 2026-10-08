import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Calendario que se despliega bajo el reloj.
PanelWindow {
    id: root
    visible: false

    anchors { top: true; right: true }
    margins { top: 6; right: 10 }
    exclusiveZone: 0
    implicitWidth: 300
    implicitHeight: col.implicitHeight + 32
    color: "transparent"
    WlrLayershell.namespace: "quickshell-calendar"

    property date today: new Date()
    property int month: today.getMonth()
    property int year: today.getFullYear()

    onVisibleChanged: {
        if (visible) {
            today = new Date();
            month = today.getMonth();
            year = today.getFullYear();
        }
    }

    function shift(delta) {
        const d = new Date(year, month + delta, 1);
        month = d.getMonth();
        year = d.getFullYear();
    }

    Rectangle {
        anchors.fill: parent
        radius: 18
        color: Theme.base
        border.color: Theme.border
        border.width: 1

        MouseArea {
            anchors.fill: parent
            onWheel: wheel => root.shift(wheel.angleDelta.y > 0 ? -1 : 1)
        }

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 16 }
            spacing: 10

            Text {
                text: Qt.formatDate(root.today, "dddd")
                color: Theme.mauve
                font { family: Theme.font; pixelSize: 13; bold: true; capitalization: Font.Capitalize }
            }
            Text {
                text: Qt.formatDate(root.today, "d MMMM yyyy")
                color: Theme.fg
                font { family: Theme.font; pixelSize: 20; bold: true }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4

                Text {
                    text: "\uf053"
                    color: prevMouse.containsMouse ? Theme.mauve : Theme.subtext0
                    font { family: Theme.font; pixelSize: 13 }
                    MouseArea { id: prevMouse; anchors.fill: parent; anchors.margins: -6; hoverEnabled: true; onClicked: root.shift(-1) }
                }
                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(new Date(root.year, root.month, 1), "MMMM yyyy")
                    color: Theme.fg
                    font { family: Theme.font; pixelSize: 13; bold: true; capitalization: Font.Capitalize }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { root.month = root.today.getMonth(); root.year = root.today.getFullYear(); }
                    }
                }
                Text {
                    text: "\uf054"
                    color: nextMouse.containsMouse ? Theme.mauve : Theme.subtext0
                    font { family: Theme.font; pixelSize: 13 }
                    MouseArea { id: nextMouse; anchors.fill: parent; anchors.margins: -6; hoverEnabled: true; onClicked: root.shift(1) }
                }
            }

            DayOfWeekRow {
                Layout.fillWidth: true
                locale: grid.locale
                delegate: Text {
                    required property string shortName
                    text: shortName.slice(0, 2)
                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.overlay1
                    font { family: Theme.font; pixelSize: 11; bold: true }
                }
            }

            MonthGrid {
                id: grid
                Layout.fillWidth: true
                month: root.month
                year: root.year
                spacing: 2

                delegate: Rectangle {
                    required property var model
                    readonly property bool isToday: model.today
                    readonly property bool inMonth: model.month === grid.month

                    implicitHeight: 30
                    radius: 8
                    color: isToday ? Theme.mauve : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: parent.model.day
                        color: parent.isToday ? Theme.base : parent.inMonth ? Theme.fg : Theme.surface2
                        font { family: Theme.font; pixelSize: 12; bold: parent.isToday }
                    }
                }
            }
        }
    }
}

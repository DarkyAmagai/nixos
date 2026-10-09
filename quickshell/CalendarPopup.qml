import Quickshell
import QtQuick
import QtQuick.Layouts

// Calendario que se despliega bajo el reloj.
PopupPanel {
    id: root
    panelWidth: 300

    property date today: new Date()
    property int month: today.getMonth()
    property int year: today.getFullYear()

    onOpenChanged: {
        if (open) {
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

    component NavButton: Rectangle {
        id: nav
        property string icon
        signal clicked()
        implicitWidth: 26
        implicitHeight: 26
        radius: 8
        color: navMouse.containsMouse ? Theme.surface0 : "transparent"
        Text {
            anchors.centerIn: parent
            text: nav.icon
            color: navMouse.containsMouse ? Theme.mauve : Theme.subtext0
            font { family: Theme.font; pixelSize: 12 }
        }
        MouseArea {
            id: navMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: nav.clicked()
        }
    }

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

        NavButton { icon: ""; onClicked: root.shift(-1) }
        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDate(new Date(root.year, root.month, 1), "MMMM yyyy")
            color: Theme.fg
            font { family: Theme.font; pixelSize: 13; bold: true; capitalization: Font.Capitalize }
            MouseArea {
                anchors.fill: parent
                // Clic: volver al mes actual · Rueda: cambiar de mes
                onClicked: { root.month = root.today.getMonth(); root.year = root.today.getFullYear(); }
                onWheel: wheel => root.shift(wheel.angleDelta.y > 0 ? -1 : 1)
            }
        }
        NavButton { icon: ""; onClicked: root.shift(1) }
    }

    // Rejilla propia (7x6): MonthGrid no da ancho a sus celdas y no dibujaba los días.
    GridLayout {
        id: grid
        Layout.fillWidth: true
        columns: 7
        rowSpacing: 2
        columnSpacing: 2

        readonly property int firstDow: Qt.locale().firstDayOfWeek
        readonly property var start: {
            const first = new Date(root.year, root.month, 1);
            const offset = (first.getDay() - firstDow + 7) % 7;
            return new Date(root.year, root.month, 1 - offset);
        }

        Repeater {
            model: 7
            Text {
                required property int index
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                horizontalAlignment: Text.AlignHCenter
                text: Qt.locale().dayName((grid.firstDow + index) % 7, Locale.ShortFormat).slice(0, 2)
                color: Theme.overlay1
                font { family: Theme.font; pixelSize: 11; bold: true }
            }
        }

        Repeater {
            model: 42
            Rectangle {
                id: cell
                required property int index
                readonly property var day: new Date(grid.start.getFullYear(), grid.start.getMonth(), grid.start.getDate() + index)
                readonly property bool inMonth: day.getMonth() === root.month
                readonly property bool isToday: day.toDateString() === root.today.toDateString()

                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 30
                radius: 8
                color: isToday ? Theme.mauve : dayMouse.containsMouse ? Theme.surface0 : "transparent"
                Behavior on color { ColorAnimation { duration: Theme.animFast } }

                Text {
                    anchors.centerIn: parent
                    text: cell.day.getDate()
                    color: cell.isToday ? Theme.base : cell.inMonth ? Theme.fg : Theme.surface2
                    font { family: Theme.font; pixelSize: 12; bold: cell.isToday }
                }

                MouseArea { id: dayMouse; anchors.fill: parent; hoverEnabled: true }
            }
        }
    }
}

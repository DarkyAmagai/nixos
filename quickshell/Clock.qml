import Quickshell
import QtQuick

Text {
    id: root
    signal clicked()

    SystemClock { id: clock; precision: SystemClock.Minutes }

    text: "  " + Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm")
    color: mouse.containsMouse ? Theme.mauve : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}

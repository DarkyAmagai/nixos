import Quickshell
import QtQuick

Text {
    property bool active: false

    SystemClock { id: clock; precision: SystemClock.Minutes }

    text: "  " + Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm")
    color: active ? Theme.mauve : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize; bold: true }
    Behavior on color { ColorAnimation { duration: Theme.animFast } }
}

import Quickshell
import QtQuick

Text {
    SystemClock { id: clock; precision: SystemClock.Minutes }

    text: Qt.formatDateTime(clock.date, "ddd d MM HH:mm")
    color: "#cdd6f4"
    font { family: "JetBrainsMono Nerd Font"; pixelSize: 13; bold: true }
}

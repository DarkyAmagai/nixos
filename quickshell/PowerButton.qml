import QtQuick

Rectangle {
    implicitWidth: 28
    implicitHeight: 28
    radius: width / 2
    color: mouse.containsMouse || ShellState.powerMenuOpen ? Theme.red : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    Text {
        anchors.centerIn: parent
        text: ""
        color: mouse.containsMouse || ShellState.powerMenuOpen ? Theme.base : Theme.red
        font { family: Theme.font; pixelSize: 14 }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: ShellState.togglePowerMenu()
    }
}

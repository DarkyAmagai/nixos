import QtQuick

Rectangle {
    id: root
    implicitWidth: 28
    implicitHeight: 28
    radius: width / 2
    color: mouse.containsMouse || ShellState.launcherOpen ? Theme.hoverBg : "transparent"
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    Image {
        anchors.centerIn: parent
        source: "nixos.svg"
        sourceSize.width: 20
        sourceSize.height: 20
        fillMode: Image.PreserveAspectFit
        smooth: true
        rotation: ShellState.launcherOpen ? 60 : 0
        Behavior on rotation { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: ShellState.toggleLauncher()
    }
}

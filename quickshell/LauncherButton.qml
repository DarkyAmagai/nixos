import Quickshell.Hyprland
import QtQuick

Item {
  id: root
  signal clicked()
  implicitWidth: 28
  implicitHeight: 28

  property bool hovered: false

  Image {
    anchors.centerIn: parent
    source: "nixos.svg"
    sourceSize.width: 22
    sourceSize.height: 22
    fillMode: Image.PreserveAspectFit
    smooth: true
    opacity: root.hovered ? 1.0 : 0.85
    Behavior on opacity { NumberAnimation { duration: 150 } }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: root.hovered = true
    onExited: root.hovered = false
    onClicked: root.clicked()
  }
}
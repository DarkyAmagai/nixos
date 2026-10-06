import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
  required property var modelData
  screen: modelData

  anchors { top: true; left: true; right: true }
  implicitHeight: 42
  color: "transparent"

  Launcher { id: launcher }

  Rectangle {
    anchors.fill: parent
    anchors { topMargin: 8; leftMargin: 10; rightMargin: 10 }
    radius: height / 2
    color: "#cc1e1e2e"
    border.color: "#40cba6f7"
    border.width: 1

    LauncherButton {
      anchors.left: parent.left
      anchors.leftMargin: 18
      anchors.verticalCenter: parent.verticalCenter
      onClicked: launcher.toggle()
    }

    Workspaces {
      anchors.left: parent.left
      anchors.leftMargin: 58
      anchors.verticalCenter: parent.verticalCenter
    }

    WindowTitle {
      anchors.centerIn: parent
    }

    RowLayout {
      anchors.right: parent.right
      anchors.rightMargin: 18
      anchors.verticalCenter: parent.verticalCenter
      spacing: 16
      Volume {}
      Clock {}
    }
  }
}
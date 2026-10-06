import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root
    visible: false

    function toggle() {
        root.visible = !root.visible;
        if (root.visible) {
            search.text = "";
            search.forceActiveFocus();
        }
    }

    anchors { top: true; left: true; right: true; bottom: true }
    color: "transparent"

    WlrLayershell.keyboardFocus: root.visible
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None
    
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    Rectangle {
        width: 500
        height: 400
        anchors.centerIn: parent
        radius: 14
        color: "#1e1e2e"
        border.color: "#cba6f7"
        border.width: 2

        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            TextField {
                id: search
                Layout.fillWidth: true
                placeholderText: "Search..."
                color: "#cdd6f4"
                font { family: "JetBrainsMono Nerd Font"; pixelSize: 16 }
                background: Rectangle {
                    radius: 8
                    color: "#313244"
                }
                Keys.onEscapePressed: root.visible = false
                Keys.onReturnPressed: {
                    if (appList.count > 0) {
                        appList.itemAtIndex(0).launch()
                        root.visible = false
                    }
                }
            }
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 4

                model: {
                    const q = search.text.toLowerCase();
                    return DesktopEntries.applications.values
                        .filter(a => !a.noDisplay && a.name.toLowerCase().includes(q))
                        .sort((x, y) => x.name.localeCompare(y.name));
                }

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    function launch() { modelData.execute(); }

                    width: appList.width
                    height: 44
                    radius: 8
                    color: index === 0 ? "#45475a" : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        spacing: 12

                        IconImage {
                            implicitSize: 28
                            source: Quickshell.iconPath(modelData.icon, true)
                        }
                        Text {
                            text: modelData.name
                            color: "#cdd6f4"
                            font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { modelData.execute(); root.visible = false; }
                    }
                }
            }
        }
    }
}
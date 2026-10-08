import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root
    visible: ShellState.powerMenuOpen

    anchors { top: true; left: true; right: true; bottom: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-power"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    property int selected: 0

    readonly property var actions: [
        { key: Qt.Key_L, icon: "\uf023", label: "Bloquear",  color: Theme.blue,   cmd: ["loginctl", "lock-session"] },
        { key: Qt.Key_E, icon: "\uf08b", label: "Salir",     color: Theme.teal,   cmd: ["hyprctl", "dispatch", "exit"] },
        { key: Qt.Key_S, icon: "\uf186", label: "Suspender", color: Theme.yellow, cmd: ["systemctl", "suspend"] },
        { key: Qt.Key_R, icon: "\uf021", label: "Reiniciar", color: Theme.peach,  cmd: ["systemctl", "reboot"] },
        { key: Qt.Key_P, icon: "\uf011", label: "Apagar",    color: Theme.red,    cmd: ["systemctl", "poweroff"] }
    ]

    function close() { ShellState.powerMenuOpen = false; }

    function run(i) {
        const a = actions[i];
        if (!a) return;
        close();
        Quickshell.execDetached(a.cmd);
    }

    onVisibleChanged: {
        if (visible) {
            selected = 0;
            keys.forceActiveFocus();
            openAnim.restart();
        }
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: Theme.scrim
        MouseArea { anchors.fill: parent; onClicked: root.close() }
    }

    Item {
        id: keys
        anchors.fill: parent
        focus: true
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) root.close();
            else if (event.key === Qt.Key_Left || event.key === Qt.Key_H || event.key === Qt.Key_Backtab)
                root.selected = (root.selected + root.actions.length - 1) % root.actions.length;
            else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab)
                root.selected = (root.selected + 1) % root.actions.length;
            else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space)
                root.run(root.selected);
            else {
                const i = root.actions.findIndex(a => a.key === event.key);
                if (i < 0) return;
                root.run(i);
            }
            event.accepted = true;
        }
    }

    ColumnLayout {
        id: content
        anchors.centerIn: parent
        spacing: 28

        ParallelAnimation {
            id: openAnim
            NumberAnimation { target: content; property: "scale"; from: 0.92; to: 1; duration: Theme.anim; easing.type: Easing.OutCubic }
            NumberAnimation { target: content; property: "opacity"; from: 0; to: 1; duration: Theme.anim }
            NumberAnimation { target: scrim; property: "opacity"; from: 0; to: 1; duration: Theme.anim }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Hasta luego, " + (Quickshell.env("USER") ?? "")
            color: Theme.fg
            font { family: Theme.font; pixelSize: 22; bold: true }
        }

        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 18

            Repeater {
                model: root.actions

                Rectangle {
                    id: btn
                    required property var modelData
                    required property int index
                    readonly property bool active: index === root.selected

                    width: 120
                    height: 132
                    radius: 20
                    color: active ? Theme.surface0 : Theme.base
                    border.color: active ? modelData.color : Theme.border
                    border.width: active ? 2 : 1
                    scale: active ? 1.05 : 1
                    Behavior on scale { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: Theme.animFast } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 12

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: btn.modelData.icon
                            color: btn.modelData.color
                            font { family: Theme.font; pixelSize: 38 }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: btn.modelData.label
                            color: btn.active ? Theme.fg : Theme.subtext0
                            font { family: Theme.font; pixelSize: 13; bold: btn.active }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selected = btn.index
                        onClicked: root.run(btn.index)
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "L bloquear · E salir · S suspender · R reiniciar · P apagar · esc cancelar"
            color: Theme.overlay0
            font { family: Theme.font; pixelSize: 11 }
        }
    }
}

import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root
    visible: ShellState.launcherOpen

    anchors { top: true; left: true; right: true; bottom: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-launcher"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    property int selected: 0

    // Puntuación simple: prefijo > inicio de palabra > contiene > genérico/keywords > fuzzy.
    function score(app, q) {
        const name = (app.name ?? "").toLowerCase();
        if (name.startsWith(q)) return 100;
        if (name.split(/[\s\-_.]+/).some(w => w.startsWith(q))) return 80;
        if (name.includes(q)) return 60;
        if ((app.genericName ?? "").toLowerCase().includes(q)) return 40;
        if (Array.from(app.keywords ?? []).join(" ").toLowerCase().includes(q)) return 30;
        if ((app.comment ?? "").toLowerCase().includes(q)) return 20;
        let i = 0;
        for (const c of name) if (c === q[i]) i++;
        return i === q.length ? 10 : 0;
    }

    readonly property var results: {
        const q = search.text.trim().toLowerCase();
        const apps = DesktopEntries.applications.values.filter(a => !a.noDisplay);
        if (q === "")
            return apps.sort((x, y) => x.name.localeCompare(y.name));
        return apps
            .map(a => ({ a: a, s: root.score(a, q) }))
            .filter(o => o.s > 0)
            .sort((x, y) => y.s - x.s || x.a.name.localeCompare(y.a.name))
            .map(o => o.a);
    }

    onResultsChanged: selected = 0

    onVisibleChanged: {
        if (visible) {
            search.text = "";
            selected = 0;
            list.positionViewAtBeginning();
            search.forceActiveFocus();
            openAnim.restart();
        }
    }

    function close() { ShellState.launcherOpen = false; }

    function launch(app) {
        if (!app) return;
        app.execute();
        close();
    }

    function move(delta) {
        if (results.length === 0) return;
        selected = (selected + delta + results.length) % results.length;
        list.positionViewAtIndex(selected, ListView.Contain);
    }

    // Fondo oscurecido; clic fuera cierra.
    Rectangle {
        id: scrim
        anchors.fill: parent
        color: Theme.scrim
        MouseArea { anchors.fill: parent; onClicked: root.close() }
    }

    Rectangle {
        id: card
        width: 580
        height: 480
        anchors.centerIn: parent
        radius: 18
        color: Theme.base
        border.color: Theme.border
        border.width: 1

        ParallelAnimation {
            id: openAnim
            NumberAnimation { target: card; property: "scale"; from: 0.94; to: 1; duration: Theme.anim; easing.type: Easing.OutCubic }
            NumberAnimation { target: card; property: "opacity"; from: 0; to: 1; duration: Theme.anim; easing.type: Easing.OutCubic }
            NumberAnimation { target: scrim; property: "opacity"; from: 0; to: 1; duration: Theme.anim }
        }

        // Evita que clics dentro de la tarjeta la cierren.
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            TextField {
                id: search
                Layout.fillWidth: true
                Layout.preferredHeight: 46
                leftPadding: 44
                placeholderText: "Buscar aplicaciones…"
                placeholderTextColor: Theme.overlay0
                color: Theme.fg
                selectionColor: Theme.mauve
                selectedTextColor: Theme.base
                font { family: Theme.font; pixelSize: 16 }
                background: Rectangle {
                    radius: 12
                    color: Theme.surface0
                    border.color: search.activeFocus ? Theme.mauve : "transparent"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf002"
                        color: Theme.mauve
                        font { family: Theme.font; pixelSize: 15 }
                    }
                }

                Keys.onPressed: event => {
                    const ctrl = event.modifiers & Qt.ControlModifier;
                    if (event.key === Qt.Key_Escape) root.close();
                    else if (event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (ctrl && event.key === Qt.Key_N)) root.move(1);
                    else if (event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (ctrl && event.key === Qt.Key_P)) root.move(-1);
                    else if (event.key === Qt.Key_PageDown) root.move(6);
                    else if (event.key === Qt.Key_PageUp) root.move(-6);
                    else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) root.launch(root.results[root.selected]);
                    else return;
                    event.accepted = true;
                }
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 2
                boundsBehavior: Flickable.StopAtBounds
                model: root.results
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Rectangle {
                    id: entry
                    required property var modelData
                    required property int index
                    readonly property bool isSelected: index === root.selected
                    readonly property string subtitle: modelData.genericName || modelData.comment || ""

                    width: list.width
                    height: 52
                    radius: 12
                    color: isSelected ? Theme.surface0 : "transparent"
                    Behavior on color { ColorAnimation { duration: Theme.animFast } }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 3
                        height: entry.isSelected ? 24 : 0
                        radius: 2
                        color: Theme.mauve
                        Behavior on height { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 14

                        IconImage {
                            implicitSize: 32
                            source: Quickshell.iconPath(entry.modelData.icon, "application-x-executable")
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                Layout.fillWidth: true
                                text: entry.modelData.name
                                elide: Text.ElideRight
                                color: entry.isSelected ? Theme.fg : Theme.subtext1
                                font { family: Theme.font; pixelSize: 14; bold: entry.isSelected }
                            }
                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: entry.subtitle
                                elide: Text.ElideRight
                                color: Theme.overlay1
                                font { family: Theme.font; pixelSize: 11 }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // positionChanged (no entered) para que el scroll con teclado no robe la selección.
                        onPositionChanged: root.selected = entry.index
                        onClicked: root.launch(entry.modelData)
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: list.count === 0
                    text: "Sin resultados"
                    color: Theme.overlay0
                    font { family: Theme.font; pixelSize: 14 }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: "↑↓ navegar   ⏎ abrir   esc cerrar"
                    color: Theme.overlay0
                    font { family: Theme.font; pixelSize: 11 }
                }
                Text {
                    text: list.count + " apps"
                    color: Theme.overlay0
                    font { family: Theme.font; pixelSize: 11 }
                }
            }
        }
    }
}

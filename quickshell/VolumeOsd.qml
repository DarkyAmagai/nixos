import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

// Indicador flotante que aparece al cambiar el volumen.
PanelWindow {
    id: root
    visible: false

    anchors.bottom: true
    margins.bottom: 90
    exclusiveZone: 0
    implicitWidth: 320
    implicitHeight: 56
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-osd"
    mask: Region {}

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: [ root.sink ] }

    // No mostrar el OSD por los cambios iniciales al arrancar.
    property bool armed: false
    Timer { interval: 1500; running: true; onTriggered: root.armed = true }

    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged() { root.show(); }
        function onMutedChanged() { root.show(); }
    }

    function show() {
        if (!armed) return;
        visible = true;
        hideTimer.restart();
    }

    Timer { id: hideTimer; interval: 1400; onTriggered: root.visible = false }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Theme.barBg
        border.color: Theme.border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 14

            Text {
                text: root.muted || root.vol === 0 ? "\uf026" : root.vol < 0.5 ? "\uf027" : "\uf028"
                color: root.muted ? Theme.overlay0 : Theme.mauve
                font { family: Theme.font; pixelSize: 18 }
                Layout.preferredWidth: 20
            }

            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: Theme.surface0

                Rectangle {
                    width: parent.width * Math.min(1, root.vol)
                    height: parent.height
                    radius: 4
                    color: root.muted ? Theme.overlay0 : Theme.mauve
                    Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                }
            }

            Text {
                text: Math.round(root.vol * 100)
                color: Theme.fg
                horizontalAlignment: Text.AlignRight
                font { family: Theme.font; pixelSize: 13; bold: true }
                Layout.preferredWidth: 28
            }
        }
    }
}

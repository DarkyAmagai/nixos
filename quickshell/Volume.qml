import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Text {
    id: root
    property bool active: false
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: [ root.sink ] }

    readonly property string icon: muted || vol === 0 ? ""
                                 : vol < 0.5 ? ""
                                 : ""

    text: icon + "  " + (muted ? "mute" : Math.round(vol * 100) + "%")
    color: muted ? Theme.overlay0 : active ? Theme.mauve : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize }
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    // Rueda sube/baja volumen. No acepta botones: el clic pasa a la pildora
    // (que abre el centro de control).
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: wheel => {
            if (!root.sink?.audio) return;
            const d = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1, root.vol + d));
        }
    }
}

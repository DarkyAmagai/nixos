import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Text {
    id: root
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: [ root.sink ] }

    readonly property string icon: muted || vol === 0 ? ""
                                 : vol < 0.5 ? ""
                                 : ""

    text: icon + "  " + (muted ? "mute" : Math.round(vol * 100) + "%")
    color: muted ? Theme.overlay0 : mouse.containsMouse ? Theme.mauve : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize }
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        // Clic izq: silenciar · Clic der: mezclador · Rueda: volumen
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                Quickshell.execDetached(["pavucontrol"]);
            else if (root.sink?.audio)
                root.sink.audio.muted = !root.muted;
        }
        onWheel: wheel => {
            if (!root.sink?.audio) return;
            const d = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1, root.vol + d));
        }
    }
}

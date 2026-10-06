import Quickshell.Services.Pipewire
import QtQuick

Text {
    id: root
    property var sink: Pipewire.defaultAudioSink
    property real vol: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false
    
    PwObjectTracker { objects: [ root.sink ] }

    text: (muted ? " " : " ") + Math.round(vol*100) + "%"
    color: muted ? "#6c7086" : "#cdd6f4"
    font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: if (root.sink?.audio) root.sink.audio.muted = !root.muted
        onWheel: wheel => {
            if (!root.sink?.audio) return;
            const d = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.sink.audio.volume = Math.max(0, Math.min(1, root.vol + d));
        }
    }
}

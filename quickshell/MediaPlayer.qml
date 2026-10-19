import Quickshell
import Quickshell.Services.Mpris
import QtQuick

// Reproductor en la barra: título + artista y play/pausa. Oculto sin reproductor.
MouseArea {
    id: root
    readonly property var players: Mpris.players.values
    // Prefiere uno reproduciendo; si no, el primero disponible.
    readonly property var player: {
        if (players.length === 0) return null;
        return players.find(p => p.playbackState === MprisPlaybackState.Playing) ?? players[0];
    }
    readonly property bool has: player !== null && (player?.trackTitle ?? "") !== ""

    visible: has
    implicitWidth: has ? row.implicitWidth : 0
    implicitHeight: 22
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: if (player?.canTogglePlaying) player.togglePlaying()

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.player?.isPlaying ? "" : ""
            color: Theme.green
            font { family: Theme.font; pixelSize: 11 }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                const t = root.player?.trackTitle ?? "";
                const a = root.player?.trackArtist ?? "";
                return a ? a + "  ·  " + t : t;
            }
            width: Math.min(implicitWidth, 260)
            elide: Text.ElideRight
            color: Theme.subtext1
            font { family: Theme.font; pixelSize: Theme.fontSize }
        }
    }
}

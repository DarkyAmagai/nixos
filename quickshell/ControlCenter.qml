import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PopupPanel {
    id: root
    panelWidth: 360

    // --- Audio de salida y entrada ---
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    PwObjectTracker { objects: [ root.sink, root.source ] }

    // --- Reproductor activo ---
    readonly property var players: Mpris.players.values
    readonly property var player: {
        if (players.length === 0) return null;
        return players.find(p => p.playbackState === MprisPlaybackState.Playing) ?? players[0];
    }
    readonly property bool hasMedia: player !== null && (player?.trackTitle ?? "") !== ""

    // --- Batería ---
    readonly property var batDev: UPower.displayDevice
    readonly property bool hasBat: batDev?.isLaptopBattery ?? false

    // --- Daemon de perfiles ---
    property bool ppdAvailable: true
    Process {
        id: ppdCheck
        command: ["systemctl", "is-active", "--quiet", "power-profiles-daemon.service"]
        onExited: (code) => root.ppdAvailable = code === 0
    }
    Connections {
        target: root
        function onOpenChanged() { if (root.open) ppdCheck.running = true; }
    }

    component Ctl: Text {
        property bool ctlEnabled: true
        color: ctlEnabled ? Theme.subtext1 : Theme.surface2
        font { family: Theme.font; pixelSize: 15 }
    }

    Text {
        text: "Centro de control"
        color: Theme.fg
        font { family: Theme.font; pixelSize: 15; bold: true }
    }

    // --- Tarjeta de música ---
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        visible: root.hasMedia
        implicitHeight: 76
        radius: 14
        color: Theme.surface0

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 12

            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                radius: 10
                color: Theme.surface1
                clip: true
                Image {
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready
                }
                Text {
                    anchors.centerIn: parent
                    visible: (root.player?.trackArtUrl ?? "") === ""
                    text: ""
                    color: Theme.overlay1
                    font { family: Theme.font; pixelSize: 22 }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    Layout.fillWidth: true
                    text: root.player?.trackTitle ?? ""
                    elide: Text.ElideRight
                    color: Theme.fg
                    font { family: Theme.font; pixelSize: 13; bold: true }
                }
                Text {
                    Layout.fillWidth: true
                    text: root.player?.trackArtist ?? ""
                    elide: Text.ElideRight
                    color: Theme.subtext0
                    font { family: Theme.font; pixelSize: 11 }
                }
                RowLayout {
                    Layout.topMargin: 2
                    spacing: 16
                    Ctl {
                        text: ""
                        enabled: root.player?.canGoPrevious ?? false
                        MouseArea { anchors.fill: parent; anchors.margins: -4; enabled: parent.ctlEnabled
                            cursorShape: Qt.PointingHandCursor; onClicked: root.player.previous() }
                    }
                    Ctl {
                        text: root.player?.isPlaying ? "" : ""
                        color: Theme.mauve
                        enabled: root.player?.canTogglePlaying ?? false
                        MouseArea { anchors.fill: parent; anchors.margins: -4; enabled: parent.ctlEnabled
                            cursorShape: Qt.PointingHandCursor; onClicked: root.player.togglePlaying() }
                    }
                    Ctl {
                        text: ""
                        enabled: root.player?.canGoNext ?? false
                        MouseArea { anchors.fill: parent; anchors.margins: -4; enabled: parent.ctlEnabled
                            cursorShape: Qt.PointingHandCursor; onClicked: root.player.next() }
                    }
                }
            }
        }
    }

    // --- Deslizador de volumen de salida ---
    Slider {
        Layout.fillWidth: true
        Layout.topMargin: 6
        icon: (root.sink?.audio?.muted ?? false) ? "" : ""
        fillColor: Theme.mauve
        value: root.sink?.audio?.volume ?? 0
        onMoved: v => { if (root.sink?.audio) root.sink.audio.volume = v; }
    }

    // --- Deslizador de micrófono ---
    Slider {
        Layout.fillWidth: true
        visible: root.source !== null
        icon: (root.source?.audio?.muted ?? false) ? "" : ""
        fillColor: Theme.teal
        value: root.source?.audio?.volume ?? 0
        onMoved: v => { if (root.source?.audio) root.source.audio.volume = v; }
    }

    Rectangle { Layout.fillWidth: true; Layout.topMargin: 2; implicitHeight: 1; color: Theme.surface0 }

    // --- Perfil de energía ---
    Text {
        text: "Modo de energía"
        color: Theme.overlay1
        font { family: Theme.font; pixelSize: 12; bold: true }
    }
    RowLayout {
        Layout.fillWidth: true
        spacing: 6
        Repeater {
            model: [
                { profile: PowerProfile.PowerSaver,  icon: "", label: "Ahorro",      color: Theme.green },
                { profile: PowerProfile.Balanced,    icon: "", label: "Equilibrado", color: Theme.blue },
                { profile: PowerProfile.Performance, icon: "", label: "Máximo",      color: Theme.peach }
            ]
            Rectangle {
                id: btn
                required property var modelData
                readonly property bool active: root.ppdAvailable && PowerProfiles.profile === modelData.profile
                visible: modelData.profile !== PowerProfile.Performance || PowerProfiles.hasPerformanceProfile
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 52
                radius: 12
                opacity: root.ppdAvailable ? 1 : 0.4
                color: active ? Theme.surface1 : bm.containsMouse ? Theme.surface0 : "transparent"
                border.color: active ? modelData.color : Theme.surface0
                border.width: 1
                Behavior on color { ColorAnimation { duration: Theme.animFast } }
                Column {
                    anchors.centerIn: parent
                    spacing: 3
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: btn.modelData.icon
                        color: btn.active ? btn.modelData.color : Theme.subtext0; font { family: Theme.font; pixelSize: 15 } }
                    Text { anchors.horizontalCenter: parent.horizontalCenter; text: btn.modelData.label
                        color: btn.active ? Theme.fg : Theme.subtext0; font { family: Theme.font; pixelSize: 10; bold: btn.active } }
                }
                MouseArea { id: bm; anchors.fill: parent; enabled: root.ppdAvailable; hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor; onClicked: PowerProfiles.profile = btn.modelData.profile }
            }
        }
    }

    // --- Pie: batería + red ---
    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 2
        spacing: 12
        Text {
            visible: root.hasBat
            text: "  " + Math.round((root.batDev?.percentage ?? 0) * 100) + "%"
            color: Theme.subtext0
            font { family: Theme.font; pixelSize: 11 }
        }
        Item { Layout.fillWidth: true }
        Network { id: netInfo }
        Text {
            text: netInfo.connName || (netInfo.kind === "none" ? "Sin red" : "")
            color: Theme.subtext0
            font { family: Theme.font; pixelSize: 11 }
        }
    }
}

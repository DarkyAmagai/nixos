import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

PopupPanel {
    id: root
    panelWidth: 320

    readonly property var dev: UPower.displayDevice
    readonly property real pct: (dev?.percentage ?? 0) * 100
    readonly property int bstate: dev?.state ?? UPowerDeviceState.Unknown
    readonly property bool charging: bstate === UPowerDeviceState.Charging
    readonly property bool full: bstate === UPowerDeviceState.FullyCharged
    readonly property color levelColor: charging || full ? Theme.green
                                      : pct <= 15 ? Theme.red
                                      : pct <= 30 ? Theme.peach
                                      : Theme.blue

    function fmtTime(s) {
        if (!s || s <= 0) return "";
        const h = Math.floor(s / 3600);
        const m = Math.round((s % 3600) / 60);
        return h > 0 ? h + " h " + m + " min" : m + " min";
    }

    readonly property string statusText: {
        if (charging) {
            const t = fmtTime(dev?.timeToFull);
            return t ? "Cargando · llena en " + t : "Cargando";
        }
        if (full) return "Carga completa";
        if (bstate === UPowerDeviceState.PendingCharge) return "Conectado, sin cargar";
        if (bstate === UPowerDeviceState.Discharging) {
            const t = fmtTime(dev?.timeToEmpty);
            return t ? "Quedan " + t : "Con batería";
        }
        return "Batería";
    }

    readonly property real health: {
        const h = dev?.healthPercentage ?? 0;
        return h <= 1 ? h * 100 : h;
    }

    component Label: Text {
        color: Theme.overlay1
        font { family: Theme.font; pixelSize: 12 }
    }
    component Value: Text {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignRight
        color: Theme.fg
        font { family: Theme.font; pixelSize: 12; bold: true }
    }

    // Encabezado: icono, porcentaje y estado
    RowLayout {
        Layout.fillWidth: true
        spacing: 14

        Rectangle {
            implicitWidth: 48
            implicitHeight: 48
            radius: 14
            color: Theme.surface0

            Text {
                anchors.centerIn: parent
                text: root.charging ? ""
                    : root.pct > 85 ? ""
                    : root.pct > 60 ? ""
                    : root.pct > 35 ? ""
                    : root.pct > 10 ? ""
                    : ""
                color: root.levelColor
                font { family: Theme.font; pixelSize: 20 }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: Math.round(root.pct) + "%"
                color: Theme.fg
                font { family: Theme.font; pixelSize: 26; bold: true }
            }
            Text {
                Layout.fillWidth: true
                text: root.statusText
                elide: Text.ElideRight
                color: Theme.subtext0
                font { family: Theme.font; pixelSize: 12 }
            }
        }
    }

    // Barra de nivel
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 10
        radius: 5
        color: Theme.surface0

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.pct / 100))
            height: parent.height
            radius: 5
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: Qt.darker(root.levelColor, 1.25) }
                GradientStop { position: 1; color: root.levelColor }
            }
            Behavior on width { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
        }
    }

    // Detalles
    GridLayout {
        Layout.fillWidth: true
        Layout.topMargin: 4
        columns: 2
        rowSpacing: 6
        columnSpacing: 12

        Label { text: "Consumo"; visible: (root.dev?.changeRate ?? 0) !== 0 }
        Value { text: Math.abs(root.dev?.changeRate ?? 0).toFixed(1) + " W"; visible: (root.dev?.changeRate ?? 0) !== 0 }

        Label { text: "Energía"; visible: (root.dev?.energyCapacity ?? 0) > 0 }
        Value {
            text: (root.dev?.energy ?? 0).toFixed(1) + " / " + (root.dev?.energyCapacity ?? 0).toFixed(1) + " Wh"
            visible: (root.dev?.energyCapacity ?? 0) > 0
        }

        Label { text: "Salud"; visible: root.dev?.healthSupported ?? false }
        Value { text: Math.round(root.health) + "%"; visible: root.dev?.healthSupported ?? false }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 1
        color: Theme.surface0
    }

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
                readonly property bool active: PowerProfiles.profile === modelData.profile

                visible: modelData.profile !== PowerProfile.Performance || PowerProfiles.hasPerformanceProfile
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 58
                radius: 12
                color: active ? Theme.surface1 : btnMouse.containsMouse ? Theme.surface0 : "transparent"
                border.color: active ? modelData.color : Theme.surface0
                border.width: 1
                Behavior on color { ColorAnimation { duration: Theme.animFast } }

                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: btn.modelData.icon
                        color: btn.active ? btn.modelData.color : Theme.subtext0
                        font { family: Theme.font; pixelSize: 16 }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: btn.modelData.label
                        color: btn.active ? Theme.fg : Theme.subtext0
                        font { family: Theme.font; pixelSize: 11; bold: btn.active }
                    }
                }

                MouseArea {
                    id: btnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: PowerProfiles.profile = btn.modelData.profile
                }
            }
        }
    }
}

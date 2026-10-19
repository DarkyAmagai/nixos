import Quickshell
import Quickshell.Io
import QtQuick

// Indicador de red vía nmcli. Clic abre nm-connection-editor.
Text {
    id: root
    property bool active: false
    property string kind: "none"     // wifi | ethernet | none
    property string connName: ""

    Process {
        id: proc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.kind = "none"; root.connName = "";
                for (const line of text.split("\n")) {
                    const f = line.split(":");
                    if (f[1] === "connected" && f[0] !== "loopback") {
                        root.kind = f[0] === "wifi" ? "wifi" : "ethernet";
                        root.connName = f[2] || "";
                        break;
                    }
                }
            }
        }
    }

    Timer { interval: 5000; running: true; repeat: true; onTriggered: proc.running = true }

    text: kind === "wifi" ? "" : kind === "ethernet" ? "󰈀" : "󰈀"
    color: active ? Theme.mauve : kind === "none" ? Theme.red : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize }
    Behavior on color { ColorAnimation { duration: Theme.animFast } }
}

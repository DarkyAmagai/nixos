import Quickshell
import Quickshell.Io
import QtQuick

// CPU y RAM leídos de /proc. Sin procesos externos.
Row {
    id: root
    spacing: 12

    property real cpu: 0      // 0..1
    property real mem: 0      // 0..1
    property var prevStat: null

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: { statFile.reload(); memFile.reload(); }
    }

    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: {
            const line = text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
            const idle = line[3] + line[4];
            const total = line.reduce((a, b) => a + b, 0);
            if (root.prevStat) {
                const dt = total - root.prevStat.total;
                const di = idle - root.prevStat.idle;
                if (dt > 0) root.cpu = Math.max(0, Math.min(1, 1 - di / dt));
            }
            root.prevStat = { total: total, idle: idle };
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const m = {};
            for (const l of text().split("\n")) {
                const p = l.split(":");
                if (p.length === 2) m[p[0]] = parseInt(p[1]);
            }
            if (m.MemTotal) root.mem = 1 - (m.MemAvailable / m.MemTotal);
        }
    }

    component Stat: Row {
        property string icon
        property real frac
        property color accent
        spacing: 5
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: parent.icon
            color: parent.accent
            font { family: Theme.font; pixelSize: 13 }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(parent.frac * 100) + "%"
            color: Theme.fg
            font { family: Theme.font; pixelSize: Theme.fontSize }
        }
    }

    Stat { icon: ""; frac: root.cpu; accent: root.cpu > 0.85 ? Theme.red : Theme.blue }
    Stat { icon: "󰍛"; frac: root.mem; accent: root.mem > 0.9 ? Theme.red : Theme.teal }
}

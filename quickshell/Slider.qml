import QtQuick

// Deslizador horizontal reutilizable (0..1). Arrastra o haz clic.
Item {
    id: root
    property real value: 0
    property color fillColor: Theme.mauve
    property string icon: ""
    signal moved(real v)

    implicitHeight: 24

    function setFromX(x) {
        const v = Math.max(0, Math.min(1, (x - track.x) / track.width));
        root.moved(v);
    }

    Text {
        id: ic
        visible: root.icon !== ""
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: root.icon
        color: Theme.subtext0
        font { family: Theme.font; pixelSize: 14 }
        width: visible ? 22 : 0
    }

    Rectangle {
        id: track
        anchors.left: ic.right
        anchors.leftMargin: root.icon !== "" ? 6 : 0
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 8
        radius: 4
        color: Theme.surface0

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.value))
            height: parent.height
            radius: 4
            color: root.fillColor
            Behavior on width { enabled: !drag.pressed; NumberAnimation { duration: Theme.animFast } }
        }

        Rectangle {
            id: knob
            width: 14
            height: 14
            radius: 7
            color: Theme.fg
            border.color: root.fillColor
            border.width: 2
            anchors.verticalCenter: parent.verticalCenter
            x: Math.max(0, Math.min(track.width - width, track.width * root.value - width / 2))
            scale: drag.pressed ? 1.2 : 1
            Behavior on scale { NumberAnimation { duration: Theme.animFast } }
        }

        MouseArea {
            id: drag
            anchors.fill: parent
            anchors.margins: -8
            onPressed: mouse => root.setFromX(mouse.x + track.x - 8 + parent.x)
            onPositionChanged: mouse => { if (pressed) root.setFromX(mouse.x + track.x - 8 + parent.x); }
        }
    }
}

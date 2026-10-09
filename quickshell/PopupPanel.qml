import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// Base de los paneles que se despliegan desde la barra (calendario, batería...).
// Se cierra al hacer clic fuera gracias al focus grab de Hyprland.
PanelWindow {
    id: root
    required property var barWindow
    property bool open: false
    property real rightOffset: 10
    property int panelWidth: 300
    default property alias content: body.data
    signal dismissed()

    // Sigue visible mientras dura la animación de cierre.
    visible: open || hideDelay.running
    anchors { top: true; right: true }
    margins { top: 6; right: rightOffset }
    exclusiveZone: 0
    implicitWidth: panelWidth
    implicitHeight: body.implicitHeight + 36
    color: "transparent"

    // El grab se activa un instante después de abrir: si se activa antes de que
    // el panel esté mapeado, Hyprland lo ignora y el clic fuera no lo cierra.
    HyprlandFocusGrab {
        id: grab
        windows: [ root, root.barWindow ]
        onCleared: root.dismissed()
    }

    Timer {
        id: grabDelay
        interval: 60
        onTriggered: grab.active = root.open
    }

    Timer {
        id: hideDelay
        interval: Theme.anim + 30
    }

    onOpenChanged: {
        if (open) {
            hideDelay.stop();
            grabDelay.restart();
        } else {
            grab.active = false;
            hideDelay.restart();
        }
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 20
        color: Theme.popupBg
        border.color: Theme.border
        border.width: 1

        opacity: root.open ? 1 : 0
        transform: Translate {
            y: root.open ? 0 : -10
            Behavior on y { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }
        }
        Behavior on opacity { NumberAnimation { duration: Theme.anim; easing.type: Easing.OutCubic } }

        ColumnLayout {
            id: body
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 18 }
            spacing: 10
        }
    }
}

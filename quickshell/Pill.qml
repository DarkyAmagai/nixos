import QtQuick
import QtQuick.Layouts

// Contenedor redondeado para agrupar módulos de la barra.
// Con `interactive: true` reacciona al hover y emite clicked().
Rectangle {
    id: root
    default property alias content: row.data
    property int padding: 12
    property alias spacing: row.spacing
    property bool interactive: false
    property bool active: false
    signal clicked()

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: 28
    radius: height / 2
    color: active ? Theme.pillActive
         : interactive && mouse.containsMouse ? Theme.pillHover
         : Theme.pillBg
    border.color: active ? Theme.border : "transparent"
    border.width: 1
    Behavior on color { ColorAnimation { duration: Theme.animFast } }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 12
    }
}

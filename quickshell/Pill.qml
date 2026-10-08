import QtQuick
import QtQuick.Layouts

// Contenedor redondeado para agrupar módulos de la barra.
Rectangle {
    default property alias content: row.data
    property int padding: 12
    property alias spacing: row.spacing

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: 26
    radius: height / 2
    color: Theme.pillBg

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 12
    }
}

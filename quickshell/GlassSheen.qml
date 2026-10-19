import QtQuick

// Capa de brillo para dar efecto cristal: un reflejo sutil arriba.
Rectangle {
    anchors.fill: parent
    radius: parent.radius
    color: "transparent"
    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.glassSheen }
        GradientStop { position: 0.4; color: "transparent" }
    }
}

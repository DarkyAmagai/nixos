import Quickshell.Wayland
import QtQuick

Text {
    text: ToplevelManager.activeTopLevel?.title ?? ""
    width: Math.min(implicitWidth, 400)
    elide: Text.ElideRight
    color: "#bac2de"
    font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
}

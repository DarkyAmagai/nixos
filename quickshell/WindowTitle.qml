import Quickshell.Wayland
import QtQuick

Text {
    property real maxWidth: 400
    readonly property var toplevel: ToplevelManager.activeToplevel

    text: toplevel?.title ?? ""
    visible: text !== ""
    width: Math.min(implicitWidth, maxWidth)
    elide: Text.ElideRight
    color: Theme.subtext1
    font { family: Theme.font; pixelSize: Theme.fontSize }
}

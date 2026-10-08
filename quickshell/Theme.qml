pragma Singleton
import Quickshell
import QtQuick

// Paleta Catppuccin Mocha + tokens compartidos por todos los componentes.
Singleton {
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"
    readonly property color fg: "#cdd6f4"
    readonly property color mauve: "#cba6f7"
    readonly property color blue: "#89b4fa"
    readonly property color sapphire: "#74c7ec"
    readonly property color teal: "#94e2d5"
    readonly property color green: "#a6e3a1"
    readonly property color yellow: "#f9e2af"
    readonly property color peach: "#fab387"
    readonly property color red: "#f38ba8"

    readonly property color barBg: "#d91e1e2e"
    readonly property color pillBg: "#99313244"
    readonly property color hoverBg: "#45475a"
    readonly property color scrim: "#99000000"
    readonly property color border: "#40cba6f7"

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13

    readonly property int animFast: 140
    readonly property int anim: 220
}

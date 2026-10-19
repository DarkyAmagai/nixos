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

    // Fondos semitransparentes: Hyprland aplica blur detrás (layerrule).
    readonly property color barBg: "#8c1e1e2e"
    readonly property color popupBg: "#a61e1e2e"
    readonly property color pillBg: "#59313244"
    readonly property color pillHover: "#8c45475a"
    readonly property color pillActive: "#b345475a"
    readonly property color hoverBg: "#45475a"
    readonly property color scrim: "#80000000"
    readonly property color border: "#33cba6f7"

    // Glass: brillo superior y borde claro para el efecto esmerilado.
    readonly property color glassSheen: "#18ffffff"
    readonly property color glassEdge: "#26ffffff"

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13

    readonly property int animFast: 90
    readonly property int anim: 150
}

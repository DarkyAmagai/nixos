//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens
        Bar {}
    }

    Launcher {}
    PowerMenu {}
    VolumeOsd {}

    // quickshell ipc call launcher toggle
    IpcHandler {
        target: "launcher"
        function toggle(): void { ShellState.toggleLauncher(); }
    }

    // quickshell ipc call power toggle
    IpcHandler {
        target: "power"
        function toggle(): void { ShellState.togglePowerMenu(); }
    }
}

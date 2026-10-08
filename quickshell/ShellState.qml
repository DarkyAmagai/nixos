pragma Singleton
import Quickshell
import QtQuick

// Estado global de los overlays (se controla desde la barra y por IPC).
Singleton {
    property bool launcherOpen: false
    property bool powerMenuOpen: false

    function toggleLauncher() {
        powerMenuOpen = false;
        launcherOpen = !launcherOpen;
    }

    function togglePowerMenu() {
        launcherOpen = false;
        powerMenuOpen = !powerMenuOpen;
    }
}

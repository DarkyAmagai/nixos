import Quickshell.Services.UPower
import QtQuick

// Indicador de batería para la barra (el panel de detalles está en BatteryPopup).
Text {
    id: root
    property bool active: false
    readonly property var dev: UPower.displayDevice
    readonly property bool present: dev?.isLaptopBattery ?? false
    readonly property real pct: (dev?.percentage ?? 0) * 100
    readonly property bool charging: dev?.state === UPowerDeviceState.Charging
                                  || dev?.state === UPowerDeviceState.FullyCharged

    readonly property string icon: charging ? ""
                                 : pct > 85 ? ""
                                 : pct > 60 ? ""
                                 : pct > 35 ? ""
                                 : pct > 10 ? ""
                                 : ""

    text: icon + "  " + Math.round(pct) + "%"
    color: active ? Theme.mauve
         : charging ? Theme.green
         : pct <= 15 ? Theme.red
         : pct <= 30 ? Theme.peach
         : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize; bold: active }
    Behavior on color { ColorAnimation { duration: Theme.animFast } }
}

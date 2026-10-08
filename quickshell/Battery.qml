import Quickshell.Services.UPower
import QtQuick

// Solo aparece si hay batería de portátil.
Text {
    id: root
    readonly property var dev: UPower.displayDevice
    readonly property real pct: (dev?.percentage ?? 0) * 100
    readonly property bool charging: dev?.state === UPowerDeviceState.Charging
                                  || dev?.state === UPowerDeviceState.FullyCharged

    visible: dev?.isLaptopBattery ?? false

    readonly property string icon: charging ? ""
                                 : pct > 85 ? ""
                                 : pct > 60 ? ""
                                 : pct > 35 ? ""
                                 : pct > 10 ? ""
                                 : ""

    text: icon + "  " + Math.round(pct) + "%"
    color: charging ? Theme.green : pct <= 15 ? Theme.red : pct <= 30 ? Theme.peach : Theme.fg
    font { family: Theme.font; pixelSize: Theme.fontSize }
}

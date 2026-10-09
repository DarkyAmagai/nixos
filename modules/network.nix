{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        # Captura / análisis
        wireshark
        termshark
        tcpdump
        # MITM / spoofing
        bettercap
        ettercap
        responder
        # Wi-Fi
        aircrack-ng
        kismet
        reaverwps
        # Utilidades de conexión
        netcat-gnu
        socat
        nftables
        iperf3
        # Escaneo autenticado de red
        netexec
    ];
}

{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        wireshark
        tcpdump
        bettercap
        aircrack-ng
        netcat-gnu
        kismet
    ];
}

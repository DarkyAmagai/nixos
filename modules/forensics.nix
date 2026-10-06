{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        binwalk
        foremost
        volatility3
        ghidra
        radare2
        exiftool
    ];
}
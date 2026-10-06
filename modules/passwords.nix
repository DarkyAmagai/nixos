{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        john
        hashcat
        hydra
        thc-hydra
        hashcat-utils
    ];
}
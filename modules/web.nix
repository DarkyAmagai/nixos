{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        burpsuite
        ffuf
        gobuster
        feroxbuster
        nikto
        sqlmap
        wpscan
        zap
        wfuzz
    ];
}

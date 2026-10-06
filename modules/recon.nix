{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        nmap
        masscan
        rustscan
        whois
        dnsutils
        theharvester
        amass
        subfinder
        exploitdb
        enum4linux
        dnsrecon
        dnsenum
    ];
}

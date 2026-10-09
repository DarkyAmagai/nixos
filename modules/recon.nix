{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        # Escaneo de puertos / red
        nmap
        masscan
        rustscan
        naabu
        # DNS / subdominios
        whois
        dnsutils
        dnsrecon
        dnsenum
        fierce
        subfinder
        amass
        dnsx
        # Recolección / enumeración
        theharvester
        enum4linux
        enum4linux-ng
        snmpcheck
        onesixtyone
        nbtscan
        # Exploits y utilidades
        exploitdb
        httpx
        asnmap
    ];
}

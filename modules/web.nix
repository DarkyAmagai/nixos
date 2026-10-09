{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        # Proxies / suites
        burpsuite
        zap
        mitmproxy
        # Fuzzing / descubrimiento de contenido
        ffuf
        gobuster
        feroxbuster
        wfuzz
        dirb
        # Escáneres
        nikto
        nuclei
        sqlmap
        wpscan
        whatweb
        wafw00f
        # Listas de palabras
        seclists
        wordlists
    ];
}

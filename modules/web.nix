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
        # Añadidos del kit (verificados en nixpkgs aarch64)
        commix
        dirbuster
    ];


    # Enlace a la ruta clásica /usr/share/wordlists (como en Kali) para que los
    # writeups y herramientas la encuentren. Incluye rockyou.txt y seclists.
    systemd.tmpfiles.rules = [
        "L+ /usr/share/wordlists - - - - ${pkgs.wordlists}/share/wordlists"
    ];

}

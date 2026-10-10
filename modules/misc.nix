{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        # Navegador / VPN
        brave
        openvpn
        wireguard-tools
        # Lenguajes / entornos para scripts y exploits
        python3
        python3Packages.pip
        python3Packages.requests
        python3Packages.pwntools
        pipx
        uv
        claude-code
        go
        ruby
        powershell
        # Utilidades de terminal
        gh
        git
        jq
        ripgrep
        fd
        fzf
        bat
        tmux
        xclip
        wl-clipboard
        # Transferencia / análisis rápido
        wget
        curl
        httpie
        ffuf
        # Contenedores para labs
        docker-compose
        # Info del sistema
        fastfetch
    ];
    virtualisation.docker.enable = true;
}

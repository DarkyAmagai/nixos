{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        brave
        python3
        python3Packages.pip
        pkgs.pipx
        powershell
        openvpn
        fastfetch
	gh
    ];
}

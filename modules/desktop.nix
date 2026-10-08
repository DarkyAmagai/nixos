{ config, pkgs, inputs, ... }:
{
    programs.hyprland.enable = true;

    # Pantalla de login en TTY que arranca Hyprland (recuerda usuario y sesión).
    services.greetd = {
        enable = true;
        settings.default_session = {
            user = "greeter";
            command = builtins.concatStringsSep " " [
                "${pkgs.tuigreet}/bin/tuigreet"
                "--time"
                "--remember"
                "--remember-session"
                "--asterisks"
                "--greeting 'Bienvenido a macky'"
                "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
            ];
        };
    };

    # PAM para hyprlock (si no, no acepta la contraseña).
    security.pam.services.hyprlock = { };

    security.rtkit.enable = true;

    # Batería en la barra de Quickshell.
    services.upower.enable = true;

    fonts = {
        packages = with pkgs; [
            nerd-fonts.jetbrains-mono
            nerd-fonts.symbols-only
            noto-fonts
            noto-fonts-color-emoji
            inter
        ];
        fontconfig.defaultFonts = {
            monospace = [ "JetBrainsMono Nerd Font" ];
            sansSerif = [ "Inter" "Noto Sans" ];
            serif = [ "Noto Serif" ];
            emoji = [ "Noto Color Emoji" ];
        };
    };

    programs.thunar = {
        enable = true;
        plugins = with pkgs; [
            thunar-archive-plugin
            thunar-volman
        ];
    };
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";

    environment.systemPackages = with pkgs; [
        inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
        swaybg
        grim           # capturas
        slurp          # selección de región
        wl-clipboard
        brightnessctl
        playerctl
        pavucontrol
        hyprpicker
        libnotify
    ];
}

{ ... }:
let
    font = "JetBrainsMono Nerd Font";
in
{
    # Bloqueo de pantalla
    programs.hyprlock = {
        enable = true;
        settings = {
            general = {
                hide_cursor = true;
                grace = 0;
            };
            background = [{
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
                brightness = 0.6;
            }];
            label = [
                {
                    text = "$TIME";
                    font_size = 96;
                    font_family = font;
                    color = "rgb(cdd6f4)";
                    position = "0, 160";
                    halign = "center";
                    valign = "center";
                }
                {
                    text = "cmd[update:60000] date +'%A %d %B'";
                    font_size = 20;
                    font_family = font;
                    color = "rgb(cba6f7)";
                    position = "0, 70";
                    halign = "center";
                    valign = "center";
                }
            ];
            input-field = [{
                size = "320, 54";
                outline_thickness = 2;
                rounding = -1;
                outer_color = "rgb(cba6f7) rgb(89b4fa) 45deg";
                inner_color = "rgb(313244)";
                font_color = "rgb(cdd6f4)";
                check_color = "rgb(a6e3a1)";
                fail_color = "rgb(f38ba8)";
                fail_text = "Contraseña incorrecta";
                placeholder_text = "Contraseña…";
                dots_center = true;
                fade_on_empty = false;
                position = "0, -40";
                halign = "center";
                valign = "center";
            }];
        };
    };

    # Bloqueo y apagado de pantalla por inactividad
    services.hypridle = {
        enable = true;
        settings = {
            general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
            };
            listener = [
                {
                    timeout = 300;
                    on-timeout = "loginctl lock-session";
                }
                {
                    timeout = 600;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
            ];
        };
    };

    # Notificaciones
    services.mako = {
        enable = true;
        settings = {
            font = "${font} 11";
            anchor = "top-right";
            margin = "12";
            padding = "14";
            width = 380;
            border-size = 2;
            border-radius = 14;
            background-color = "#1e1e2eee";
            text-color = "#cdd6f4";
            border-color = "#cba6f7";
            progress-color = "over #45475a";
            icons = true;
            max-icon-size = 48;
            default-timeout = 5000;
            "urgency=low" = {
                border-color = "#45475a";
            };
            "urgency=high" = {
                border-color = "#f38ba8";
                default-timeout = 0;
            };
        };
    };

    # Historial del portapapeles ($mod SHIFT V)
    services.cliphist.enable = true;

    # Lanzador alternativo / dmenu ($mod SHIFT D)
    programs.fuzzel = {
        enable = true;
        settings = {
            main = {
                font = "${font}:size=12";
                terminal = "kitty";
                icon-theme = "Papirus-Dark";
                prompt = "'❯ '";
                width = 42;
                lines = 12;
                horizontal-pad = 20;
                vertical-pad = 14;
                inner-pad = 8;
            };
            colors = {
                background = "1e1e2ef2";
                text = "cdd6f4ff";
                prompt = "cba6f7ff";
                placeholder = "6c7086ff";
                input = "cdd6f4ff";
                match = "cba6f7ff";
                selection = "45475aff";
                selection-text = "cdd6f4ff";
                selection-match = "cba6f7ff";
                border = "cba6f7ff";
            };
            border = {
                width = 2;
                radius = 14;
            };
        };
    };
}

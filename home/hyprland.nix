{ ... }:
let
    qs = "quickshell ipc call";
    screenshotDir = "~/Pictures/Screenshots";
in
{
    wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        package = null; # --System Package--
        portalPackage = null;
        settings = {
            "$mod" = "SUPER";
            # En Parallels la resolución sigue al tamaño de la ventana (maximizada en
            # la MacBook Pro 16": 3456x2168). Escala 2 = 1728x1084 lógicos, como macOS.
            monitor = ",preferred,auto,2";
            exec-once = [
                "quickshell"
                "swaybg -i ~/.config/background.jpg -m fill"
            ];

            env = [
                "QT_QPA_PLATFORMTHEME,qt6ct"
                "XCURSOR_SIZE,24"
            ];

            input = {
                kb_layout = "latam";
                follow_mouse = 1;
                sensitivity = 0;
                touchpad = {
                    natural_scroll = true;
                    tap-to-click = true;
                    disable_while_typing = true;
                };
            };

            bind = [
                # Apps
                "$mod, Return, exec, kitty"
                "$mod, D, exec, ${qs} launcher toggle"
                "$mod SHIFT, D, exec, fuzzel"
                "$mod, E, exec, thunar"
                "$mod, B, exec, brave"
                "$mod, X, exec, ${qs} power toggle"
                "$mod CTRL, L, exec, loginctl lock-session"
                "$mod SHIFT, V, exec, cliphist list | fuzzel --dmenu --prompt 'clip ❯ ' | cliphist decode | wl-copy"
                "$mod SHIFT, C, exec, hyprpicker -a"

                # Ventanas
                "$mod, Q, killactive"
                "$mod SHIFT, M, exit"
                "$mod, F, fullscreen"
                "$mod, V, togglefloating"
                "$mod, P, pseudo"
                "$mod, T, layoutmsg, togglesplit"
                "$mod, C, centerwindow"

                # Foco (flechas y vim)
                "$mod, left, movefocus, l"
                "$mod, right, movefocus, r"
                "$mod, up, movefocus, u"
                "$mod, down, movefocus, d"
                "$mod, H, movefocus, l"
                "$mod, L, movefocus, r"
                "$mod, K, movefocus, u"
                "$mod, J, movefocus, d"

                # Mover ventanas
                "$mod SHIFT, left, movewindow, l"
                "$mod SHIFT, right, movewindow, r"
                "$mod SHIFT, up, movewindow, u"
                "$mod SHIFT, down, movewindow, d"
                "$mod SHIFT, H, movewindow, l"
                "$mod SHIFT, L, movewindow, r"
                "$mod SHIFT, K, movewindow, u"
                "$mod SHIFT, J, movewindow, d"

                # Workspaces
                "$mod, Tab, workspace, e+1"
                "$mod SHIFT, Tab, workspace, e-1"
                "$mod, mouse_down, workspace, e+1"
                "$mod, mouse_up, workspace, e-1"

                # Scratchpad
                "$mod, S, togglespecialworkspace, magic"
                "$mod ALT, S, movetoworkspace, special:magic"

                # Capturas (portapapeles + archivo)
                "$mod SHIFT, S, exec, mkdir -p ${screenshotDir} && grim -g \"$(slurp)\" - | tee ${screenshotDir}/$(date +%F_%H-%M-%S).png | wl-copy && notify-send 'Captura' 'Región copiada al portapapeles'"
                ", Print, exec, mkdir -p ${screenshotDir} && grim - | tee ${screenshotDir}/$(date +%F_%H-%M-%S).png | wl-copy && notify-send 'Captura' 'Pantalla copiada al portapapeles'"
                "$mod, Print, exec, mkdir -p ${screenshotDir} && grim - | tee ${screenshotDir}/$(date +%F_%H-%M-%S).png | wl-copy && notify-send 'Captura' 'Pantalla copiada al portapapeles'"
            ] ++ (builtins.concatLists (builtins.genList (i:
                let ws = toString (i + 1); in [
                    "$mod, ${ws}, workspace, ${ws}"
                    "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
                ]) 9));

            # Teclas multimedia (repiten al mantener y funcionan con pantalla bloqueada)
            bindel = [
                ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
                ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
                ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
            ];
            bindl = [
                ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioPause, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"
            ];

            bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
            ];

            general = {
                gaps_in = 5;
                gaps_out = 10;
                border_size = 2;
                "col.active_border" = "rgba(cba6f7ff) rgba(89b4faff) 45deg";
                "col.inactive_border" = "rgba(45475aaa)";
                layout = "dwindle";
                resize_on_border = true;
            };

            dwindle = {
                preserve_split = true;
            };

            decoration = {
                rounding = 12;
                active_opacity = 1.0;
                inactive_opacity = 0.92;
                dim_special = 0.3;
                blur = {
                    enabled = true;
                    size = 6;
                    passes = 3;
                    vibrancy = 0.17;
                    popups = true;
                };
                shadow = {
                    enabled = true;
                    range = 16;
                    render_power = 3;
                    color = "rgba(11111bcc)";
                };
            };

            animations = {
                enabled = true;
                bezier = [
                    "suave, 0.05, 0.9, 0.1, 1.05"
                    "easeOut, 0.16, 1, 0.3, 1"
                    "linear, 0, 0, 1, 1"
                ];
                animation = [
                    "windows, 1, 6, suave, slide"
                    "windowsOut, 1, 5, easeOut, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 80, linear, loop"
                    "fade, 1, 6, default"
                    "layers, 1, 4, easeOut, fade"
                    "workspaces, 1, 5, easeOut, slide"
                    "specialWorkspace, 1, 5, easeOut, slidevert"
                ];
            };

            misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                focus_on_activate = true;
                mouse_move_enables_dpms = true;
                key_press_enables_dpms = true;
            };
        };
    };
}

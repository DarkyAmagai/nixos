{ config, pkgs, ... }:
{
    home.username = "ph1shr";
    home.homeDirectory = "/home/ph1shr";
    home.stateVersion = "26.05";
    programs.fish = {
        enable = true;
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/nixos#macky";
            ll = "ls -la";
        };
        plugins = [
            {
                name = "tide";
                src = pkgs.fishPlugins.tide.src;
            }
        ];
    };
	programs.kitty = {
		enable = true;
		themeFile = "Catppuccin-Mocha";
		font = {
			name = "JetBrainsMono Nerd Font";
			size = 12;
		};
		settings = {
			background_opacity = 0.9;
			window_padding_width = 10;
		};
	};

    qt = {
        enable = true;
        platformTheme.name = "qtct";
    };

    xdg.configFile."qt6ct/qt6ct.conf".text = ''
        [Appearance]
        style=Fusion
        color_scheme_path=${config.xdg.configHome}/qt6ct/colors/dark.conf
        custom_palette=true
        icon_theme=Papirus-Dark
    '';

    xdg.configFile."qt6ct/colors/dark.conf".text = ''
        [ColorScheme]
        active_colors=#ffcdd6f4, #ff1e1e2e, #ff313244, #ff45475a, #ff11111b, #ff181825, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff1e1e2e, #ff181825, #ff11111b, #ff89b4fa, #ff1e1e2e, #ff89b4fa, #ffcba6f7, #ff1e1e2e, #ff000000, #ff1e1e2e, #ffcdd6f4, #80181825
        disabled_colors=#ff6c7086, #ff1e1e2e, #ff313244, #ff45475a, #ff11111b, #ff181825, #ff6c7086, #ffffffff, #ff6c7086, #ff1e1e2e, #ff181825, #ff11111b, #ff45475a, #ff6c7086, #ff89b4fa, #ffcba6f7, #ff1e1e2e, #ff000000, #ff1e1e2e, #ff6c7086, #80181825
        inactive_colors=#ffcdd6f4, #ff1e1e2e, #ff313244, #ff45475a, #ff11111b, #ff181825, #ffcdd6f4, #ffffffff, #ffcdd6f4, #ff1e1e2e, #ff181825, #ff11111b, #ff89b4fa, #ff1e1e2e, #ff89b4fa, #ffcba6f7, #ff1e1e2e, #ff000000, #ff1e1e2e, #ffcdd6f4, #80181825
    '';

    gtk = {
        enable = true;
        theme = {
            name = "catppuccin-mocha-blue-standard";
            package = pkgs.catppuccin-gtk.override {
                variant = "mocha";
                accents = [ "blue" ];
                size = "standard";
            };
        };
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
        };

        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
        };
    };

	home.pointerCursor = {
		gtk.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Classic";
		size = 17;
	};

    wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        package = null; # --System Package--
        portalPackage = null;
        settings = {
            "$mod" = "SUPER";
            monitor = ",preffered,auto,auto";
            exec-once = [
                "quickshell"
                "swaybg -i ~/.config/background.jpg -m fill"
            ];
            
            input.kb_layout = "latam";
            bind = [
                "$mod, Return, exec, kitty"
                "$mod, D, exec, fuzzel"
                "$mod, Q, killactive"
                "$mod, M, exit"
                "$mod, F, fullscreen"
            ] ++ (builtins.concatLists (builtins.genList (i: 
                let ws = toString (i + 1); in [
                    "$mod, ${ws}, workspace, ${ws}"
                    "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
                ]) 9));

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
                layout = "dwingle";
            };
            decoration = {
                rounding = 10;
                active_opacity = 1.0;
                inactive_opacity = 0.92;
                blur = {
                    enabled = true;
                    size = 6;
                    passes = 2;
                };
                shadow = {
                    enabled = true;
                    range = 12;
                    render_power = 3;
                    color = "rgba(1a1a1aee)";
                };
            };
            animations = {
                enabled = true;
                bezier = [ "suave, 0.05, 0.9, 0.1, 1.05" ];
                animation = [
                    "windows, 1, 6, suave"
                    "windowsOut, 1, 6, default, popin 80%"
                    "border, 1, 10, default"
                    "fade, 1, 6, default"
                    "workspaces, 1, 5, default, slide"
                ];
            };

            env = [
                "QT_QPA_PLATFORMTHEME,qt6ct"
            ];

            misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
            };
        };
    };

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/ph1shr/nixos/quickshell";
}

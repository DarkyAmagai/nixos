{ config, pkgs, ... }:
{
    imports = [
        ./home/hyprland.nix
        ./home/desktop.nix
    ];

    home.username = "ph1shr";
    home.homeDirectory = "/home/ph1shr";
    home.stateVersion = "26.05";
    programs.fish = {
        enable = true;
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/nixos#macky";
            ll = "ls -la";
        };
        interactiveShellInit = "set -g fish_greeting";
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
		size = 20; # similar al cursor de macOS
	};

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/ph1shr/nixos/quickshell";
}

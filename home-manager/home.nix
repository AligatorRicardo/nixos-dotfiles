{ config, pkgs, catppuccinifier, ... }:

{
  # Home Manager needs the paths it should manage.
  home.username = "theloremaster";
  home.homeDirectory = "/home/theloremaster";
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "23.05";

  # Defines files to annex to home.nix
  imports = [
    ./confs/hyprland.nix
    ./confs/theming.nix  
    ./confs/zsh.nix
    ./confs/git.nix
  ];

  # Allows you to install Nix packages into your environment.

  home.packages = [
    # Basic system applications
    pkgs.kitty
    pkgs.rofi-wayland
    pkgs.cinnamon.nemo-with-extensions
    pkgs.cinnamon.nemo-fileroller
    pkgs.xfce.mousepad
    pkgs.distrobox
    pkgs.godot_4
    pkgs.rclone
    pkgs.cava
    pkgs.github-desktop
    pkgs.onlyoffice-bin
    pkgs.ranger
    pkgs.kjv
    pkgs.playerctl
    # System libraries and basic components
    pkgs.wl-clipboard
    pkgs.wl-clip-persist
    pkgs.cliphist
    pkgs.feh
    pkgs.grim
    pkgs.slurp
    pkgs.gtk-engine-murrine
    pkgs.hyprpaper
    pkgs.waybar
    pkgs.swaynotificationcenter
    pkgs.swaylock-effects  
    pkgs.nwg-bar    
    pkgs.wlogout
    pkgs.nwg-dock-hyprland
    pkgs.swayosd
    pkgs.udiskie
    pkgs.xdg-user-dirs
    pkgs.libsForQt5.polkit-kde-agent
    pkgs.gnome.gvfs
    pkgs.libayatana-appindicator
    pkgs.htop
    pkgs.pamixer
    pkgs.pw-viz
    pkgs.libinput
    pkgs.libsecret
    pkgs.neofetch
    pkgs.gh
    # Fonts
    pkgs.nerdfonts
    pkgs.liberation_ttf
    pkgs.font-awesome
    catppuccinifier.packages.${pkgs.system}.cli
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  # Imports a basic kitty configuration.
  xdg.configFile."kitty/kitty.conf".source = ./confs/kitty.conf;

  # Imports a basic rofi configuration
  xdg.configFile."rofi/config.rasi".source = ./confs/config.rasi;
  #xdg.configFile."rofi/catppuccin-mocha.rasi".source = ./confs/catppuccin.rasi;
  xdg.configFile."rofi/colors-rofi-dark.rasi".source = ./confs/colors-rofi-dark.rasi;
  # xdg.configFile."rofi/powermenu.rasi".source = ./confs/powermenu.rasi;

  # Imports a basic swaync configuration
  xdg.configFile."swaync/config.json".source = ./confs/styles/swaync/config.json;
  xdg.configFile."swaync/configSchema.json".source = ./confs/styles/swaync/configSchema.json;
  xdg.configFile."swaync/style.css".source = ./confs/styles/swaync/style.css;

  # Imports a basic waybar configuration
  xdg.configFile."waybar/config".source = ./confs/styles/waybar/config;
  xdg.configFile."waybar/mocha.css".source = ./confs/styles/waybar/mocha.css;
  xdg.configFile."waybar/style.css".source = ./confs/styles/waybar/style.css;

  # Imports a basic Swaylock configuration
  xdg.configFile."swaylock/config".source = ./confs/swaylock.config;

  # Imports a basic WLogout configuration
  xdg.configFile."wlogout/style.css".source = ./confs/wlogout.css;

  # Imports a basic Godot configuration
  xdg.configFile."godot/text_editor_themes/Catppuccin.tet".source = ./confs/godot-catppuccin.tet;
  xdg.configFile."godot/editor_settings-4.tres".source = ./confs/godot-settings.tres;

  # Imports a basic Neofetch configuration
  xdg.configFile."neofetch/config.conf".source = ./confs/neofetch.config;

  # Imports a basic default apps configuration
  xdg.configFile."mimeapps.list".source = ./confs/defaultapps.list;

  # Imports a basic NWG Dock configuration
  xdg.configFile."nwg-dock-hyprland/style.css".source = ./confs/nwg-dock.css;

  # Imports a basic Ranger configuration
  xdg.configFile."ranger/rc.conf".source = ./confs/ranger.conf;

  # Imports a basic Powerlevel10k configuration
  xdg.configFile."zsh/.p10k.zsh".source = ./confs/p10k.zsh;

  # You can also manage environment variables but you will have to manually
  # source: ~/.nix-profile/etc/profile.d/hm-session-vars
  home.sessionVariables = {
  QT_QPA_PLATFORM="wayland"; 
  QT_QPA_PLATFORMTHEME="qt5ct"; 
  };

  # Enables KDE Connect
  services.kdeconnect.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

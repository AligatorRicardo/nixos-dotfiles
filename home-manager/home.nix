{ config, pkgs, catppuccinifier, nixosConfig, flakes, ... }:

{
  # Home Manager needs the paths it should manage.
  home.username = "theloremaster";
  home.homeDirectory = "/home/theloremaster";
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "23.05";

  # Imports the .nix Modules for each specific task.
  imports = [
    ./confs/hyprland.nix
    ./confs/theming.nix  
    ./confs/zsh.nix
    ./confs/git.nix
    ./confs/dotfiles.nix
  ];

  # Allows you to install Nix packages into your environment.
  home.packages = [
    # Some user-specific applications (Many were installed as Flatpaks instead)
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
    pkgs.neovim
    pkgs.htop
    catppuccinifier.packages.${pkgs.system}.cli
  ];
 
  # Manages environment variables.
  home.sessionVariables = {
  QT_QPA_PLATFORM="wayland"; 
  QT_QPA_PLATFORMTHEME="qt5ct"; 
  };

  # Enables KDE Connect
  services.kdeconnect.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

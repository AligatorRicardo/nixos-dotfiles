{ config, pkgs, ...}:

  let
   catppuccin_name = "Catppuccin-Mocha-Standard-Mauve-Dark";
     catppuccin = pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "standard";
          tweaks = [ "normal" ];
          variant = "mocha";
     };
  in

{
   gtk = {
      enable = true;
      theme = {
          name = catppuccin_name;
          package = catppuccin;
      };
      cursorTheme = {
        name = "Catppuccin-Mocha-Mauve-Cursors";
        package = pkgs.catppuccin-cursors.mochaMauve;
      };
   };  

  gtk.iconTheme.package = pkgs.tela-icon-theme;
  gtk.iconTheme.name = "Tela-purple-dark";

  home.file.".config/gtk-4.0/gtk.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk.css";
  home.file.".config/gtk-4.0/gtk-dark.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";

  home.file.".config/gtk-4.0/assets" = {
    recursive = true;
    source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/assets";
  };


  qt.enable = true;
  qt.platformTheme = "qtct";
  #qt.style.name = "kvantum";

  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      accent = "Mauve";
      variant = "Mocha";
    })
  ];

  xdg.configFile."Kvantum/kvantum.kvconfig".source = ./kvantum.conf;
  xdg.configFile."qt5ct/qt5ct.conf".source = ./qt5ct.conf;

}


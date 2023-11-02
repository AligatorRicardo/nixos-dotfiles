# Setups Flatub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install all my flatpak apps
flatpak install -y io.gitlab.librewolf-community/x86_64/stable org.godotengine.Godot/x86_64/stable net.lutris.Lutris/x86_64/stable org.qbittorrent.qBittorrent/x86_64/stable io.github.spacingbat3.webcord/x86_64/stable org.onlyoffice.desktopeditors/x86_64/stable org.kde.okular/x86_64/stable com.github.tchx84.Flatseal/x86_64/stable com.protonvpn.www/x86_64/stable org.gnome.Boxes/x86_64/stable runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08 org.gimp.GIMP/ com.github.KRTirtho.Spotube/x86_64/stable io.freetubeapp.FreeTube

# Fixes GTK and icon theming.
ln -s .nix-profile/share/themes .themes
ln -s .nix-profile/share/icons  .icons
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --env=GTK_THEME="Catppuccin-Mocha-Standard-Mauve-Dark"
sudo flatpak override --env=QT_STYLE_OVERRIDE=kvantum --filesystem=xdg-config/Kvantum:ro
#TODO: Arch container for Steam, and Ubuntu container for VSCodium

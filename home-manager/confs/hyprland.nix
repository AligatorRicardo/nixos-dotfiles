{ config, pkgs, ... }:

{

wayland.windowManager.hyprland.extraConfig = ''
# Setup Monitors
monitor=,preferred,auto,auto

# Enables wallpaper config via Hyprpaper.
exec-once = hyprpaper

# Setup Cursor theme.
exec-once=hyprctl setcursor Catppuccin-Mocha-Mauve-Cursors 24

# Starts Waybar on boot.
exec-once = waybar && mpd

# Autostarts KDE Connect Indicator.
exec-once = kdeconnect-indicator

# Failsafe option for audio.
#exec-once = wireplumber && pipewire

# Enables root access prompt (KDE Polkit Agent).
exec-once = /nix/store/5mw28ihm0lsc9q1rjjgp453klhxh68rm-polkit-kde-agent-1-5.27.7/libexec/polkit-kde-authentication-agent-1

# Enables notification support.
exec-once = swaync

# Automounts USB Drives.
exec-once = udiskie

# Executes NWG Dock (Plank-like but for wayland).
exec-once = nwg-dock-hyprland -d

# Automatically syncs folders between Android and NixOS (Syncthing)
# exec-once = syncthing

# Some default env vars.
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORM,wayland 
env = QT_QPA_PLATFORMTHEME,qt5ct

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = br
    kb_variant = abnt2
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    gaps_in = 2
    gaps_out = 5
    border_size = 2
    col.active_border = rgb(cba6f7) rgb(cba6f7) 45deg
    col.inactive_border = rgb(6c7086)
    layout = dwindle
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = off
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = ALT

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, RETURN, exec, kitty
bind = $mainMod, Q, killactive, 
bind = $mainMod, M, exec, mousepad
bind = $mainMod, E, exec, nemo
bind = $mainMod, V, togglefloating, 
bind = $mainMod, D, exec, rofi -show drun
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, F4, exit

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Defines brightness and volume control keys + screenshots.
bind = , XF86MonBrightnessDown, exec,brightnessctl set 10%-
bind = , XF86MonBrightnessUp, exec,brightnessctl set 10%+
bind = , XF86AudioRaiseVolume, exec, pamixer -i 5 
bind = , XF86AudioLowerVolume, exec, pamixer -d 5 
bind = , XF86AudioMute, exec, pamixer -t
bind = , Print, exec, grim -g "$(slurp)"
bind = SUPER, F1, exec, ~/.config/hypr/animations.sh
'';

  xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;

  xdg.configFile."hypr/animations.sh".source = ./animations.sh;

  home.packages = with pkgs; [
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
    pkgs.pamixer
    pkgs.pw-viz
    pkgs.libinput
    pkgs.libsecret
    pkgs.gh
    pkgs.git
    pkgs.playerctl
    # Fonts
    pkgs.nerdfonts
    pkgs.liberation_ttf
    pkgs.font-awesome
  ];

}

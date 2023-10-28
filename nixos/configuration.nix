# Edit this configuration file to define what should be installed on
# your system.

{ config, pkgs, ... }: 

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enables SystemD-Bootloader and Plymouth
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  # Configures kernel parameters
  boot.kernelParams = [ "quiet" "udev.log_level=3" "radeon.cik.support=0" "amdgpu.cik.support=1"  ]; # Remove radeon.cik and amd.cik when switching hardware.

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enables AppArmor support
  security.apparmor.enable = true;
  security.apparmor.killUnconfinedConfinables = true;

  # Enable swap on luks
  boot.initrd.luks.devices."luks-d52c9012-8de5-425a-ad96-b674d052e8ef".device = "/dev/disk/by-uuid/d52c9012-8de5-425a-ad96-b674d052e8ef";
  boot.initrd.luks.devices."luks-d52c9012-8de5-425a-ad96-b674d052e8ef".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Changes memory allocator to LibC (Less secure, but more functional.
  # Remove this to change to SCudo (Default) for high security tasks.
  environment.memoryAllocator.provider = "libc";

  # Enables Graphical stack (X.org/Wayland + SDDM + Hyprland WM)
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  programs.hyprland = {
   enable = true;  
   #nvidiaPatches = true; (switching hardware)
   xwayland.enable = true;
  };  

  # Removes XTerm from XServer
  services.xserver.excludePackages = [ pkgs.xterm ];  

  # Disables NixOS documentation.
  documentation.nixos.enable = false;
 
  # Defines session variables.
  environment.sessionVariables = {
   #WLR_NO_HARDWARE_CURSORS = "1"; (switching hardware)
   NIXOS_OZONE_WL = "1";
  };

 # Patches to enable OpenGL support and a NVIDIA patch.
  hardware = {
      opengl = {
        enable = true;
        driSupport = true;
       };
  };

  # Enables XDG Portals + GTK File Picker
  xdg.portal.enable = true;  
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enables sound support with Pipewire and required plugins.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
 
  # Enables NVIDIA drivers support (Switching hardware)
  # services.xserver.videoDrivers = ["nvidia"];

  # Configures NVIDIA drivers
  # hardware.nvidia = {
  #    modesetting.enable = true; # Required for all compositors.
  #    powerManagement.finegrained = true; # Turns off DGPU when not in use.
  #    open = true; # Enables open kernel drivers.
  #    nvidiaSettings = true; # Enables (although barebones) settings menu.
  #    package = config.boot.kernelPackages.nvidiaPackages.stable; # Defines stable package.
  #
  # Defines Optimus support. 
  # WARNING: this will NOT WORK until you replace "x" with iGPU bos info and Y with dGPU bus info
  # obtained by running "sudo lshw -c display" from package "lshw"
  #     prime = {
  #       sync.enable = true;
  #       amd/intelBusID = "x"
  #       nvidiaBusID = "y"
  #     };
  # };

  # Creates a specialisation on bootscreen for better battery usage with Prime Render Offload
  # specialistation = {
  #   fora-de-casa.configuration = {   
  #       system.nixos.tags = [ "fora-de-casa" ];
  #       hardware.nvidia = {
  #          prime.offload.enable = lib.mkForce true;
  #          prime.offload.enableOffloadCmd = lib.mkForce true;
  #          prime.sync.enable = lib.mkForce false;
  #       };    
  #       services.tlp = {
  #         enable = true;
  #          settings = {
  #             CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #             CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #             CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #             CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #             CPU_MIN_PERF_ON_AC = 0;
  #             CPU_MAX_PERF_ON_AC = 100;
  #             CPU_MIN_PERF_ON_BAT = 0;
  #             CPU_MAX_PERF_ON_BAT = 20;
  #             RUNTIME_PM_DRIVER_DENYLIST = "mei_me";
  #         };       
  #   };
  # };

  # Set your time zone.
  time.timeZone = "America/Fortaleza";

  # Select internationalisation and language properties
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enables ZSH Shell
  programs.zsh.enable = true;

  # Define a user account.
  users.users.theloremaster = {
    isNormalUser = true;
    description = "Loremaster";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ 
    # Don't install packages here, either install via Home-Manager or
    # as a system package for... simplicity reasons.
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
  pavucontrol
  lshw
  brightnessctl 
  cachix
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # Enable Podman support (for Distrobox)
  virtualisation = {
     podman = {
         enable = true;
         dockerCompat = true;
      };
  };

  # Enables Flatpak support.
  services.flatpak.enable = true;
 
  # Enables USB automouting (allows Udiskie on home-manager to fuction)
  services.udisks2.enable = true;

  # Enables and configures a network firewall.
  networking.firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];     
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
   };

  # Fixes Swaylock
  security.pam.services = {
     swaylock = {
        text = ''
          auth include login
        '';
     };
     kwallet = {
        name = "kwallet";
        enableKwallet = true;
     };
  };

  # Automatic backups configuration.nix of all generations. 
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.05";

}

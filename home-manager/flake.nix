{
  description = "Home Manager configuration of theloremaster";

  inputs = {
    # Specify the source of Home Manager, Nixpkgs and Hyprland module.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager/";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    hyprland.url = "github:hyprwm/Hyprland";
      catppuccinifier = {
       url = "github:lighttigerXIV/catppuccinifier";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { nixpkgs, home-manager, hyprland, catppuccinifier, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."theloremaster" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
           ./home.nix 
            hyprland.homeManagerModules.default
            {wayland.windowManager.hyprland.enable = true;}
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.ni
 
  extraSpecialArgs = {
            inherit nixpkgs catppuccinifier;
  };

      };      
    };
}

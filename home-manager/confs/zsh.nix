{ config, pkgs, ...}:
{

    programs.zsh = {
       enable = true;
       enableCompletion = true;
       enableAutosuggestions = true;
       syntaxHighlighting.enable = true;
       shellAliases = {
          nixos-update = "sudo nixos-rebuild switch && home-manager build switch";
          lf = "ranger";
       };
       oh-my-zsh = {
         enable = true;
         plugins = [ "git" ];
         theme = "alanpeabody";
       };
    };

}


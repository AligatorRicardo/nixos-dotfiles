{ config, pkgs, ...}:
{
  programs.git = {
    enable = true;
    userName  = "AligatorRicardo";
    userEmail = "aligatorricardo@protonmail.com";
     extraConfig = {
         credential.helper = "${
                pkgs.git.override { withLibsecret = true; }
                }/bin/git-credential-libsecret";
         };
 };
}

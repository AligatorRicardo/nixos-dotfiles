{ pkgs }:
let
  imgLink = "https://raw.githubusercontent.com/AligatorRicardo/nixos-dotfiles/main/Mocha-hald8-sddm-background.jpg.jpg";
  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-CGfJQN5O+PdgTI2tgP5Kk3bPIgAVNx0HPfvMJkIEccc=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "TiagoDamascena";
    repo = "sddm-sugar-catppuccin";
    rev = "a7271089a6f990b2df12f34d968a33fb6e3493c9";
    sha256 = "1m7my0wiwdwirn215mjwwc2qggqwn1vhjrby2irscmzpvwk7mcj3";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm background.jpg
    cp -r ${image} $out/background.jpg
    '';
}

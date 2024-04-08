{ inputs, pkgs, ... }:

{
  stylix = {
    image = pkgs.fetchFromGitHub {
      owner = "hyprwm";
      repo = "Hyprland";
      rev = "0e87a08e15c023325b64920d9e1159f38a090695";
      sha256 = "sha256-gM4cDw45J8mBmM0aR5Ko/zMAA8UWnQhc4uZ5Ydvc4uo=";
    } + "/assets/wall2.png";
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
  };
}

{ pkgs, ... }:
let
  specificPackages = with pkgs; [
    base16-schemes
    alacritty
    alacritty-theme
    wofi
    waybar
    wl-clipboard
    papirus-icon-theme
    lxqt.pcmanfm-qt
    satty
    grimblast
    hyprlock
    libsForQt5.qt5ctf
    libsForQt5.qtstyleplugins
    mpv
    bluetuith
    ueberzugpp
    wl-clipboard
  ];
in
{
  specificPackages = specificPackages;
}
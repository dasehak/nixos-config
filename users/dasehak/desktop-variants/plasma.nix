{ pkgs, ... }:
let
  specificPackages = with pkgs; [
    wl-clipboard
    syncthing-tray
  ] ++ (with pkgs.kdePackages; [
      gwenview
      krfb
      kmail
      sddm-kcm
      spectacle
      tokodon
      kjournald
      partitionmanager
      kpmcore
      neochat
      plasma-vault
  ]);
in
{
  specificPackages = specificPackages;
}

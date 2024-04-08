{ pkgs, ... }:
let
  specificPackages = with pkgs; [
    wl-clipboard
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
  ]);
in
{
  specificPackages = specificPackages;
}

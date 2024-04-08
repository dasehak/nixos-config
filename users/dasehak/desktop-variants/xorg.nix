{ pkgs, ... }:
let
  specificPackages = with pkgs; [
    st
    slstatus
    slock # Когда нибудь написать конфиг и пропатчить это всё
  ];
in
{
  specificPackages = specificPackages;
}

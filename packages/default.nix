{ pkgs, lib }:

{
  yscan = pkgs.callPackage ./yscan { };
  waybar = import ./waybar.nix { inherit pkgs lib; };
  yazi = import ./yazi { inherit pkgs lib; };
}

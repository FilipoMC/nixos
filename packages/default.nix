{ pkgs, lib }@args:

let
  call = path: attrs: import path (args // attrs);
  callPackage = pkgs.callPackage;
in
{
  yscan = callPackage ./yscan { };
  waybar = call ./waybar.nix { };
  vi-sql = callPackage ./vi-sql.nix { };
  resterm = callPackage ./resterm.nix { };
}

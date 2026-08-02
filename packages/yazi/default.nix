{ pkgs, ... }:

pkgs.yazi.override {
  yazi-unwrapped = pkgs.callPackage ./yazi-unwrapped.nix { };
}

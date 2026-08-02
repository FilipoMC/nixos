{ pkgs, ... }:

(pkgs.waybar.override {
  cavaSupport = false;
}).overrideAttrs
  (old: {
    src = pkgs.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "e17c0d9f0a73acc370df60ec8c532b1ed2385c73";
      hash = "sha256-p5iqMo4JPhbukRqPlYjciaU89wRPDmWSUY9NkxywI+k=";
    };

  })

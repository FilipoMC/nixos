{
  stdenv,
  pkg-config,
  gtk3,
  gtk-layer-shell,
}:

stdenv.mkDerivation {
  pname = "crosshair";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  installPhase = ''
    install -Dm755 crosshair $out/bin/crosshair
  '';
}

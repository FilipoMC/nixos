{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yscan";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yetidevworks";
    repo = "yscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dIRtqn6vismwgQUwfK5KzApBDBlAmOt+mfdBY8sr47g=";
  };

  __structuredAttrs = true;

  cargoPatches = [
    ./wayland-clipboard.patch
  ];

  cargoHash = "sha256-qYBk6X+OZrpT+wN5M5dGFLcOVaSbY4fBE1c6bB8peIs=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "TUI IP and Port Scanner";
    homepage = "https://github.com/yetidevworks/yscan";
    changelog = "https://github.com/yetidevworks/yscan/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yscan";
  };
})

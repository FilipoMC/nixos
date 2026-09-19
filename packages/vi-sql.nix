{
  lib,
  fetchFromGitHub,
  buildGoModule,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vi-sql";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kopecmaciej";
    repo = "vi-sql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CzRKumXa6Nuuec8yJ3/3xmNUGPGvr43Ih8Roq2E6DgA=";
  };

  vendorHash = "sha256-UpziJIG99qE3sWTm2qKVWFE8Yl0+ZLuRFiaD4+Sdygs=";

  ldflags = [
    "-s"
    "-X=github.com/kopecmaciej/vi-sql/internal/build.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    license = lib.licenses.asl20;
    mainProgram = "vi-sql";
  };
})

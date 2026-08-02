{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
  outputs = { self, nixpkgs, zen-browser, nix-flatpak, ... }@inputs: {
    nixosConfigurations.filipo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nix-flatpak.nixosModules.nix-flatpak

        ./configuration.nix
      ];
    };
  };
}


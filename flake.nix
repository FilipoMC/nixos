{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
  outputs =
    {
      self,
      nixpkgs,
      zen-browser,
      nix-flatpak,
      chaotic,
      ...
    }@inputs:
    {
      nixosConfigurations.filipo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          chaotic.nixosModules.nyx-cache

          ./hosts/filipo
          ./configuration.nix
        ];
      };
    };
}

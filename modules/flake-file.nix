{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "My System Config";

    inputs = {
      nixpkgs.url = lib.mkForce "github:NixOS/nixpkgs/nixos-25.05";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
      nurpkgs.url = "github:nix-community/NUR";

      flake-parts.inputs.nixpkgs-lib.follows = lib.mkForce "nixpkgs-unstable";

      home-manager = {
        url = lib.mkDefault "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    };
  };
}

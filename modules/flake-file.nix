{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "My System Config";

    inputs = {
      nixpkgs.url = lib.mkForce "github:NixOS/nixpkgs/nixos-26.05";
      # Pinned until fnm builds on nixos-unstable: docs/todo.md
      # (nixpkgs-unstable pin).
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/f9a75f41be3a74eab55d3a7679d34ad6cc0da977";

      flake-parts.inputs.nixpkgs-lib.follows = lib.mkForce "nixpkgs-unstable";

      home-manager = {
        url = lib.mkDefault "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    };
  };
}

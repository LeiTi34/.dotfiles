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
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/1d060086d60cb76a40cf37109f979d88a5bd6396";

      flake-parts.inputs.nixpkgs-lib.follows = lib.mkForce "nixpkgs-unstable";

      home-manager = {
        url = lib.mkDefault "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    };
  };
}

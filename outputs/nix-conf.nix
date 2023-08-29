{ inputs, system, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (inputs.nixpkgs) lib;
  
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
in
{
  vm = lib.nixosSystem {
    inherit lib pkgs system;
    specialArgs = { inherit inputs; };

    modules = [
      ../system/vm/configuration.nix
    ];
  };

  PCNX-LeiAle1 = lib.nixosSystem {
    inherit lib pkgs system;
    specialArgs = { inherit inputs; };

    modules = [
      ../system/PCNX-LeiAle1/configuration.nix
    ];
  };
}

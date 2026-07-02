{ config, inputs, lib, ... }:
{
  flake-file.inputs.herdr = {
    url = lib.mkDefault "github:ogulcancelik/herdr";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.homeModules.herdr = { pkgs, ... }: {
    home.packages = [
      inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  flake.modules.nixos.herdr = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.herdr
    ];
  };
}

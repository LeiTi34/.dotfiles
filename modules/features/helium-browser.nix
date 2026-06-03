{ config, inputs, lib, ... }:
{
  flake-file.inputs.helium-browser = {
    url = lib.mkDefault "github:schembriaiden/helium-browser-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.homeModules.helium-browser = { pkgs, ... }: {
    home.packages = [
      inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  flake.modules.nixos.helium-browser = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.helium-browser
    ];
  };
}

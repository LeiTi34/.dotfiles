{ config, inputs, lib, ... }:
{
  flake-file.inputs.zen-browser = {
    url = lib.mkDefault "github:0xc000022070/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
    inputs.home-manager.follows = "home-manager";
  };

  flake.homeModules.zen-browser = { pkgs, ... }: {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  flake.modules.nixos.zen-browser = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.zen-browser
    ];
  };
}

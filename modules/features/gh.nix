{ config, ... }:
{
  flake.homeModules.gh = { pkgs, ... }: {
    home.packages = [ pkgs.gh ];
  };

  flake.modules.nixos.gh = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.gh
    ];
  };
}

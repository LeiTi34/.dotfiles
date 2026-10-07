{ config, ... }:
{
  flake.homeModules.feh = { pkgs, ... }: {
    home.packages = [ pkgs.feh ];
  };

  flake.modules.nixos.feh = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.feh
    ];
  };
}

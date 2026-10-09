{ config, ... }:
{
  flake.homeModules.lutris = { pkgs, ... }: {
    home.packages = [ pkgs.lutris ];
  };

  flake.modules.nixos.lutris = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.lutris
    ];
  };
}

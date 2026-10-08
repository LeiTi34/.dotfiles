{ config, ... }:
{
  flake.homeModules.colmena = { pkgs, ... }: {
    home.packages = [ pkgs.colmena ];
  };

  flake.modules.nixos.colmena = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.colmena
    ];
  };
}

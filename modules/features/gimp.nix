{ config, ... }:
{
  flake.homeModules.gimp = { pkgs, ... }: {
    home.packages = [ pkgs.gimp ];
  };

  flake.modules.nixos.gimp = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.gimp
    ];
  };
}

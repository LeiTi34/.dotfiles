{ config, ... }:
{
  flake.homeModules.heroic = { pkgs, ... }: {
    home.packages = [ pkgs.heroic ];
  };

  flake.modules.nixos.heroic = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.heroic
    ];
  };
}

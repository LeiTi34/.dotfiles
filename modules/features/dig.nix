{ config, ... }:
{
  flake.homeModules.dig = { pkgs, ... }: {
    home.packages = [ pkgs.dig ];
  };

  flake.modules.nixos.dig = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.dig
    ];
  };
}

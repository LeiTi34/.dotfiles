{ config, ... }:
{
  flake.homeModules.zip = { pkgs, ... }: {
    home.packages = [ pkgs.zip ];
  };

  flake.modules.nixos.zip = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.zip
    ];
  };
}

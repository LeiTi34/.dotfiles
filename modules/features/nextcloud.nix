{ config, ... }:
{
  flake.homeModules.nextcloud = { pkgs, ... }: {
    home.packages = [ pkgs.nextcloud-client ];
  };

  flake.modules.nixos.nextcloud = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.nextcloud
    ];
  };
}

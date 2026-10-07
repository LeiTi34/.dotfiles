{ config, ... }:
{
  flake.homeModules.rsync = { pkgs, ... }: {
    home.packages = [ pkgs.rsync ];
  };

  flake.modules.nixos.rsync = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.rsync
    ];
  };
}

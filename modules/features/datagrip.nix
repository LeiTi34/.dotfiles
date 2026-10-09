{ config, ... }:
{
  flake.homeModules.datagrip = { pkgs, ... }: {
    home.packages = [ pkgs.jetbrains.datagrip ];
  };

  flake.modules.nixos.datagrip = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.datagrip
    ];
  };
}

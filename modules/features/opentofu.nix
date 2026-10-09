{ config, ... }:
{
  flake.homeModules.opentofu = { pkgs, ... }: {
    home.packages = [ pkgs.opentofu ];
  };

  flake.modules.nixos.opentofu = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.opentofu
    ];
  };
}

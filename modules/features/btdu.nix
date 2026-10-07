{ config, ... }:
{
  flake.homeModules.btdu = { pkgs, ... }: {
    home.packages = [ pkgs.btdu ];
  };

  flake.modules.nixos.btdu = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.btdu
    ];
  };
}

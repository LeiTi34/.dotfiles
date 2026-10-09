{ config, ... }:
{
  flake.homeModules.pcmanfm = { pkgs, ... }: {
    home.packages = [ pkgs.pcmanfm ];
  };

  flake.modules.nixos.pcmanfm = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.pcmanfm
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.thunderbird = { pkgs, ... }: {
    home.packages = [ pkgs.thunderbird ];
  };

  flake.modules.nixos.thunderbird = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.thunderbird
    ];
  };
}

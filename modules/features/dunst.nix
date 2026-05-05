{ config, ... }:
{
  flake.homeModules.dunst = {
    services.dunst.enable = true;
  };

  flake.modules.nixos.dunst = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.dunst
    ];
  };
}

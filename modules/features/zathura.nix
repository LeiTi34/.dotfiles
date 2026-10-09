{ config, ... }:
{
  flake.homeModules.zathura = {
    programs.zathura.enable = true;
  };

  flake.modules.nixos.zathura = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.zathura
    ];
  };
}

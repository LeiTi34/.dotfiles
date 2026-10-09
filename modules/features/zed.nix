{ config, ... }:
{
  flake.homeModules.zed = {
    programs.zed-editor.enable = true;
  };

  flake.modules.nixos.zed = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.zed
    ];
  };
}

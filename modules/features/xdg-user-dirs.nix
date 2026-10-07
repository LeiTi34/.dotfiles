{ config, ... }:
{
  # Defaults are the English names already in use (~/Downloads, ~/Pictures, ...).
  flake.homeModules.xdg-user-dirs = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;
    };
  };

  flake.modules.nixos.xdg-user-dirs = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.xdg-user-dirs
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.ghostty = { pkgs, ... }: {
    home.packages = [ pkgs.ghostty ];
    xdg.configFile."ghostty" = {
      source = ../../ghostty/.config/ghostty;
      recursive = true;
    };
  };

  flake.modules.nixos.ghostty = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.ghostty
    ];
  };
}

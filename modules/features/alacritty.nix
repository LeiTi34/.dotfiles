{ config, ... }:
{
  flake.homeModules.alacritty = { pkgs, ... }: {
    home.packages = [ pkgs.alacritty ];
    xdg.configFile."alacritty" = {
      source = ../../alacritty/.config/alacritty;
      recursive = true;
    };
  };

  flake.modules.nixos.alacritty = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.alacritty
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.librewolf = { pkgs, ... }: {
    home.packages = [ pkgs.librewolf ];
    home.file.".librewolf/librewolf.overrides.cfg".source =
      ../../configs/librewolf/.librewolf/librewolf.overrides.cfg;
    xdg.configFile."tridactyl/tridactylrc".source =
      ../../configs/librewolf/.config/tridactyl/tridactylrc;
  };

  flake.modules.nixos.librewolf = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.librewolf
    ];
  };
}

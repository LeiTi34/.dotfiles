{ config, ... }:
{
  flake.homeModules.librewolf = { pkgs, ... }: {
    home.packages = [ pkgs.librewolf ];
    home.file.".librewolf/librewolf.overrides.cfg".source =
      ../../librewolf/.librewolf/librewolf.overrides.cfg;
    xdg.configFile."tridactyl/tridactylrc".source =
      ../../librewolf/.config/tridactyl/tridactylrc;
  };

  flake.modules.nixos.librewolf = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.librewolf
    ];
  };
}

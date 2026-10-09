{ config, ... }:
{
  flake.homeModules.steam = { pkgs, ... }: {
    home.packages = with pkgs; [
      protonup-qt
      mangohud
    ];
  };

  flake.modules.nixos.steam = {
    # The NixOS modules, not the packages: Steam needs the controller udev
    # rules, gamemode its daemon and polkit rules.
    programs.steam = {
      enable = true;
      protontricks.enable = true;
    };
    programs.gamemode.enable = true;

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.steam
    ];
  };
}

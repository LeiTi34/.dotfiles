{ config, ... }:
{
  flake.homeModules.hyprland = { pkgs, ... }: {
    home.packages = with pkgs; [
      hyprpolkitagent
      grimblast
      cliphist
      wl-clipboard
      playerctl
      pamixer
      wireplumber
      brightnessctl
    ];

    xdg.configFile = {
      "hypr" = {
        source = ../../hyprland/.config/hypr;
        recursive = true;
      };

      "hypr/monitors.lua".source = ../../system/PCNX-LeiAle1/hyprland/monitors.lua;
    };
  };

  flake.modules.nixos.hyprland = { lib, pkgs, ... }: {
    imports = [ config.flake.modules.nixos.dms ];

    programs = {
      hyprland.enable = true;
      hyprlock.enable = true;
    };

    services = {
      hypridle.enable = lib.mkForce false;
      udev.packages = [ pkgs.brightnessctl ];
    };

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.hyprland
    ];
  };
}

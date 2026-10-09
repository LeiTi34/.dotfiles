{ config, ... }:
{
  flake.homeModules.hyprland = { lib, pkgs, ... }: {
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

    xdg.configFile."hypr" = {
      # hyprmoncfg-monitors.lua is linked out of store by the hyprmoncfg feature.
      source = lib.cleanSourceWith {
        src = ../../configs/hyprland/.config/hypr;
        filter = path: _: baseNameOf path != "hyprmoncfg-monitors.lua";
      };
      recursive = true;
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

{ config, ... }:
{
  configurations.nixos.PCNX-LeiAle1 = {
    system = "x86_64-linux";
    module = {
      imports = [
        ../../system/PCNX-LeiAle1/configuration.nix
        config.flake.modules.nixos.workstation
      ];

      home-manager.users.${config.profiles.primaryUser.name}.xdg.configFile."hypr/monitors.lua".source =
        ../../system/PCNX-LeiAle1/hyprland/monitors.lua;
    };
  };
}

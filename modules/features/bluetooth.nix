{ config, ... }:
{
  # mpris-proxy forwards headset media buttons (AVRCP) to MPRIS players.
  flake.homeModules.bluetooth = {
    services.mpris-proxy.enable = true;
  };

  flake.modules.nixos.bluetooth = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.bluetooth
    ];
  };
}

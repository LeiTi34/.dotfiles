{ config, ... }:
{
  configurations.nixos.PCNX-LeiAle1 = {
    system = "x86_64-linux";
    # Host-specific settings: modules/hosts/PCNX-LeiAle1/*.nix
    module = {
      imports = with config.flake.modules.nixos; [
        profile-default
        workstation
        avahi
        gvfs
        gnome-apps
      ];
    };
  };
}

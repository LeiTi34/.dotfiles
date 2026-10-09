{ config, ... }:
{
  configurations.nixos.TR = {
    system = "x86_64-linux";
    # Host-specific settings: modules/hosts/TR/*.nix
    module = {
      imports = with config.flake.modules.nixos; [
        profile-default
        profile-development
        profile-gaming
        gnome
        bluetooth
        headsetcontrol
        openrgb
      ];
    };
  };
}

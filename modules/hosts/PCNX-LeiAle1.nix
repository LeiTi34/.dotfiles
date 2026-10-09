{ config, ... }:
{
  configurations.nixos.PCNX-LeiAle1 = {
    system = "x86_64-linux";
    # Host-specific settings: modules/hosts/PCNX-LeiAle1/*.nix
    module = {
      imports = [
        config.flake.modules.nixos.workstation
      ];
    };
  };
}

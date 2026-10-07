{ config, ... }:
{
  configurations.nixos."840G6" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.nixos; [
        ../../system/840G6/configuration.nix
        workstation
        laptop
        fwupd
        bluetooth
        snapper
        android
        headsetcontrol
        hyprmoncfg
        vpn
      ];
    };
  };
}

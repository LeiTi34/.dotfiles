{ ... }:
{
  # RGB control (mainboard, RAM, peripherals); the server runs as root for
  # the SuperIO and SMBus access, the GUI connects to it.
  flake.modules.nixos.openrgb = { lib, ... }: {
    services.hardware.openrgb = {
      enable = true;
      motherboard = lib.mkDefault "amd";
    };
  };
}

{ ... }:
{
  # Driver for Xbox One/Series controllers over Bluetooth.
  flake.modules.nixos.xpadneo = {
    hardware.xpadneo.enable = true;
  };
}

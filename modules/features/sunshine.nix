{ ... }:
{
  # Game streaming host for Moonlight; config and pairings in ~/.config/sunshine.
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      # KMS screen capture under Wayland
      capSysAdmin = true;
      openFirewall = true;
      autoStart = false;
    };
  };
}

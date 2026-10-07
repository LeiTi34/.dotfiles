{ ... }:
{
  flake.modules.nixos.openssh = {
    services.openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
  };
}

{ ... }:
{
  # mDNS: resolve and announce <host>.local in the LAN.
  flake.modules.nixos.avahi = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        workstation = true;
      };
    };
  };
}

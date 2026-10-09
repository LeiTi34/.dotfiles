{ ... }:
{
  flake.modules.nixos.gnome-apps = { pkgs, ... }: {
    services.gnome.core-apps.enable = true;
    environment.systemPackages = [ pkgs.gnome-online-accounts ];
  };
}

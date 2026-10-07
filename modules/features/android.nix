{ ... }:
{
  # systemd's uaccess rules grant device access, no adbusers group needed.
  flake.modules.nixos.android = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.android-tools ];
  };
}

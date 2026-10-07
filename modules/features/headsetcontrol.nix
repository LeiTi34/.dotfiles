{ ... }:
{
  flake.modules.nixos.headsetcontrol = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.headsetcontrol ];
    services.udev.packages = [ pkgs.headsetcontrol ];
  };
}

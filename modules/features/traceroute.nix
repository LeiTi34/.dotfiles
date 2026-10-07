{ config, ... }:
{
  flake.homeModules.traceroute = { pkgs, ... }: {
    home.packages = [ pkgs.traceroute ];
  };

  flake.modules.nixos.traceroute = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.traceroute
    ];
  };
}

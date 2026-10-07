{ config, ... }:
{
  flake.homeModules.whois = { pkgs, ... }: {
    home.packages = [ pkgs.whois ];
  };

  flake.modules.nixos.whois = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.whois
    ];
  };
}

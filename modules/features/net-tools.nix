{ config, ... }:
{
  flake.homeModules.net-tools = { pkgs, ... }: {
    home.packages = [ pkgs.net-tools ];
  };

  flake.modules.nixos.net-tools = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.net-tools
    ];
  };
}

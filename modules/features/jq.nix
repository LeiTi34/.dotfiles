{ config, ... }:
{
  flake.homeModules.jq = { pkgs, ... }: {
    home.packages = [ pkgs.jq ];
  };

  flake.modules.nixos.jq = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.jq
    ];
  };
}

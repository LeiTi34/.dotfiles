{ config, ... }:
{
  flake.homeModules.glab = { pkgs, ... }: {
    home.packages = [ pkgs.glab ];
  };

  flake.modules.nixos.glab = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.glab
    ];
  };
}

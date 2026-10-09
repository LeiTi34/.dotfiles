{ config, ... }:
{
  flake.homeModules.azure-functions = { pkgs, ... }: {
    home.packages = [ pkgs.azure-functions-core-tools ];
  };

  flake.modules.nixos.azure-functions = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.azure-functions
    ];
  };
}

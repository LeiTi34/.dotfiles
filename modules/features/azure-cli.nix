{ config, ... }:
{
  flake.homeModules.azure-cli = { pkgs, ... }: {
    home.packages = [ pkgs.azure-cli ];
  };

  flake.modules.nixos.azure-cli = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.azure-cli
    ];
  };
}

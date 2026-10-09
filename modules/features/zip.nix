{ config, ... }:
{
  flake.homeModules.zip = { pkgs, ... }: {
    home.packages = with pkgs; [
      zip
      unzip
    ];
  };

  flake.modules.nixos.zip = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.zip
    ];
  };
}

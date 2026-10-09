{ config, ... }:
{
  flake.homeModules.libreoffice = { pkgs, ... }: {
    home.packages = [ pkgs.libreoffice-stable ];
  };

  flake.modules.nixos.libreoffice = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.libreoffice
    ];
  };
}

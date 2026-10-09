{ config, ... }:
{
  flake.homeModules.remmina = { pkgs, ... }: {
    home.packages = [ pkgs.remmina ];
  };

  flake.modules.nixos.remmina = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.remmina
    ];
  };
}

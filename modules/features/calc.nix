{ config, ... }:
{
  flake.homeModules.calc = { pkgs, ... }: {
    home.packages = [ pkgs.calc ];
  };

  flake.modules.nixos.calc = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.calc
    ];
  };
}

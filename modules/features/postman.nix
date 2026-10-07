{ config, ... }:
{
  flake.homeModules.postman = { pkgs, ... }: {
    home.packages = [ pkgs.postman ];
  };

  flake.modules.nixos.postman = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.postman
    ];
  };
}

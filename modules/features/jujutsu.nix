{ config, ... }:
{
  flake.homeModules.jujutsu = { pkgs, ... }: {
    home.packages = [ pkgs.jujutsu ];
  };

  flake.modules.nixos.jujutsu = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.jujutsu
    ];
  };
}

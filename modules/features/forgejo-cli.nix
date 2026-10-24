{ config, ... }:
{
  flake.homeModules.forgejo-cli = { pkgs, ... }: {
    home.packages = [ pkgs.forgejo-cli ];
  };

  flake.modules.nixos.forgejo-cli = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.forgejo-cli
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.rustdesk = { pkgs, ... }: {
    home.packages = [ pkgs.rustdesk ];
  };

  flake.modules.nixos.rustdesk = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.rustdesk
    ];
  };
}

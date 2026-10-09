{ config, ... }:
{
  flake.homeModules.prismlauncher = { pkgs, ... }: {
    home.packages = [ pkgs.prismlauncher ];
  };

  flake.modules.nixos.prismlauncher = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.prismlauncher
    ];
  };
}

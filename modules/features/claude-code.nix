{ config, ... }:
{
  flake.homeModules.claude-code = { pkgs, ... }: {
    home.packages = [ pkgs.claude-code ];
  };

  flake.modules.nixos.claude-code = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.claude-code
    ];
  };
}

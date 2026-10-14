{ config, ... }:
{
  flake.homeModules.direnv = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  flake.modules.nixos.direnv = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.direnv
    ];
  };
}

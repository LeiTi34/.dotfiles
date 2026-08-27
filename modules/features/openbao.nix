{ config, ... }:
{
  # `bao` CLI only, for talking to remote OpenBao servers. The local daemon
  # (services.openbao) is deliberately not enabled.
  flake.homeModules.openbao = { pkgs, ... }: {
    home.packages = [ pkgs.openbao ];
  };

  flake.modules.nixos.openbao = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.openbao
    ];
  };
}

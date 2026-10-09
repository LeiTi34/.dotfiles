{ config, ... }:
{
  flake.modules.nixos.profile-work = {
    imports = with config.flake.modules.nixos; [
      remmina
      datagrip
      openbao

      kubernetes-client

      libreoffice
    ];
  };
}

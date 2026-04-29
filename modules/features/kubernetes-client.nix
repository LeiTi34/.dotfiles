{ config, ... }:
{
  flake.homeModules.kubernetes-client = { config, lib, pkgs, ... }: {
    home = {
      packages = with pkgs; [
        kubectl
        kubernetes-helm
        argocd
        age
        sops
        velero
        lens
      ];
    };
  };

  flake.modules.nixos.kubernetes-client = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.kubernetes-client
    ];
  };
}

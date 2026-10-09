{ config, ... }:
let
  user = config.profiles.primaryUser.name;
in
{
  flake.modules.nixos.docker = { config, lib, pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      # GPUs in containers (--device nvidia.com/gpu=all) go through CDI.
      daemon.settings = lib.mkIf config.hardware.nvidia-container-toolkit.enable {
        features.cdi = true;
      };
    };
    # ~/.docker/config.json uses "credsStore": "secretservice".
    environment.systemPackages = [ pkgs.docker-credential-helpers ];
    users.extraGroups.docker.members = [ user ];

    networking.extraHosts = ''
      172.17.0.1 host.docker.internal
    '';
  };
}

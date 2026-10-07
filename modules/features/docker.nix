{ config, ... }:
{
  flake.modules.nixos.docker = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
    # ~/.docker/config.json uses "credsStore": "secretservice".
    environment.systemPackages = [ pkgs.docker-credential-helpers ];
    users.extraGroups.docker.members = [ config.profiles.primaryUser.name ];

    networking.extraHosts = ''
      172.17.0.1 host.docker.internal
    '';
  };
}

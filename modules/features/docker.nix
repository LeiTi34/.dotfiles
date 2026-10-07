{ config, ... }:
{
  flake.modules.nixos.docker = {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
    users.extraGroups.docker.members = [ config.profiles.primaryUser.name ];

    networking.extraHosts = ''
      172.17.0.1 host.docker.internal
    '';
  };
}

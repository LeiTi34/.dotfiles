{ config, ... }:
{
  flake.modules.nixos.virtualbox = {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };
    users.extraGroups.vboxusers.members = [ config.profiles.primaryUser.name ];
  };
}

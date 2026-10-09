{ config, ... }:
{
  flake.homeModules.gnupg = { pkgs, ... }: {
    home.packages = [ pkgs.gnupg ];
    # SSH keys come from rbw (bitwarden feature), not from gpg-agent.
    services.gpg-agent.enable = true;
  };

  flake.modules.nixos.gnupg = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.gnupg
    ];
  };
}

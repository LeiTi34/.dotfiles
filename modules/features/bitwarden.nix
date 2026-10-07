{ config, ... }:
{
  # rbw holds both Bitwarden vaults and serves their SSH keys. Account details
  # (email, server, SSO) are set imperatively with `rbw config set` so they
  # stay out of this public repo; see ~/.config/rbw{,-work}/config.json.
  flake.homeModules.bitwarden = { lib, pkgs, ... }: {
    home.packages = [
      pkgs.rbw
      pkgs.pinentry-qt
    ];

    # The default profile is the SSH agent; work hosts point at
    # rbw-work's socket via IdentityAgent in the untracked ~/.ssh/config.d/.
    home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
    services.gpg-agent.enableSshSupport = lib.mkForce false;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [ "config.d/*.conf" ];
    };
  };

  flake.modules.nixos.bitwarden = { lib, ... }: {
    programs.gnupg.agent.enableSSHSupport = lib.mkForce false;

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.bitwarden
    ];
  };
}

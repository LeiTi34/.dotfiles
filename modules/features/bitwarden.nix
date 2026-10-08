{ config, ... }:
{
  # rbw holds both Bitwarden vaults and serves their SSH keys. Account details
  # (email, server, SSO) are set imperatively with `rbw config set` so they
  # stay out of this public repo; see ~/.config/rbw{,-work}/config.json.
  flake.homeModules.bitwarden = { lib, pkgs, ... }:
  let
    # Upstream pinentry that keeps the master password in the Secret Service
    # keyring (unlocked at login by PAM). Enable per profile with
    # `rbw config set pinentry rbw-pinentry-keyring`.
    rbw-pinentry-keyring = pkgs.runCommand "rbw-pinentry-keyring" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = [ pkgs.bash ];
    } ''
      install -Dm755 ${pkgs.rbw.src}/bin/rbw-pinentry-keyring $out/bin/rbw-pinentry-keyring
      patchShebangs $out/bin
      # rbw may call its pinentry without arguments; upstream trips over set -u.
      substituteInPlace $out/bin/rbw-pinentry-keyring \
        --replace-fail 'command="$1"' 'command="''${1:-}"'
      wrapProgram $out/bin/rbw-pinentry-keyring \
        --prefix PATH : ${lib.makeBinPath [ pkgs.libsecret pkgs.pinentry-qt ]}
    '';
  in
  {
    home.packages = [
      pkgs.rbw
      pkgs.pinentry-qt
      rbw-pinentry-keyring
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

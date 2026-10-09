{ ... }:
{
  flake.modules.nixos.gnome = {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    # SSH keys come from rbw (bitwarden feature); GNOME would set
    # SSH_AUTH_SOCK to its own agent.
    services.gnome.gcr-ssh-agent.enable = false;
  };
}

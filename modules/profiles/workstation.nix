{ config, ... }:
{
  # Everything shared by the desktop machines; hosts add hardware and
  # machine-specific features on top.
  flake.modules.nixos.workstation = {
    imports = with config.flake.modules.nixos; [
      # system
      base
      unfree
      home-manager
      audio
      desktop
      fonts
      printing
      openssh
      docker
      virtualbox
      btrfs-maintenance

      # desktop
      hyprland
      gtk
      alacritty
      ghostty
      pcmanfm
      zathura
      nextcloud
      remmina
      libreoffice
      zen-browser
      helium-browser
      browser-control
      steam

      # shell and tools
      shell
      tmux
      git
      jujutsu
      gnupg
      bitwarden
      zip
      calc
      dig

      # development
      neovim
      zed
      dev-toolchains
      fnm
      datagrip
      kubernetes-client
      opentofu
      azure-functions
      openbao
      herdr
      opencode
    ];
  };
}

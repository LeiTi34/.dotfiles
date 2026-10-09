{ config, ... }:
{
  # Everything shared by the desktop machines; hosts add hardware and
  # machine-specific features on top.
  flake.modules.nixos.workstation = {
    imports = with config.flake.modules.nixos; [
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
      alacritty
      ghostty
      git
      gtk
      neovim
      hyprland
      shell
      fnm
      zen-browser
      helium-browser
      browser-control
      kubernetes-client
      herdr
      jujutsu
      opencode
      openbao
      bitwarden
      steam
      libreoffice
      dev-toolchains
    ];
  };
}

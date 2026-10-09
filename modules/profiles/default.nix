{ config, ... }:
{
  # The features every host gets.
  flake.modules.nixos.profile-default = {
    imports = with config.flake.modules.nixos; [
      base
      unfree
      home-manager
      alex
      audio
      desktop
      fonts
      printing
      openssh
      docker
      virtualbox
      btrfs-maintenance
      fwupd

      hyprland
      gtk
      wallpaper
      alacritty
      pcmanfm
      zathura
      nextcloud

      zen-browser
      helium-browser

      bitwarden

      shell
      tmux
      gnupg
      zip
      calc
      dig

      git
      jujutsu
    ];
  };
}

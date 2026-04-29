{ config, ... }:
{
  configurations.nixos.PCNX-LeiAle1 = {
    system = "x86_64-linux";
    module = {
      imports = [
        ../../system/PCNX-LeiAle1/configuration.nix
        config.flake.modules.nixos.unfree
        config.flake.modules.nixos.home-manager
        config.flake.modules.nixos.alacritty
        config.flake.modules.nixos.ghostty
        config.flake.modules.nixos.git
        config.flake.modules.nixos.gtk
        config.flake.modules.nixos.neovim
        config.flake.modules.nixos.qtile
        config.flake.modules.nixos.shell
        config.flake.modules.nixos.zen-browser
        config.flake.modules.nixos.kubernetes-client
      ];
    };
  };
}

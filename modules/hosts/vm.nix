{ config, ... }:
{
  configurations.nixos.vm = {
    system = "x86_64-linux";
    module = {
      imports = [
        ../../system/vm/configuration.nix
        config.flake.modules.nixos.unfree
        config.flake.modules.nixos.home-manager
        config.flake.modules.nixos.git
        config.flake.modules.nixos.neovim
        config.flake.modules.nixos.zen-browser
      ];
    };
  };
}

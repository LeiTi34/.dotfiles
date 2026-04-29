{ config, ... }:
{
  configurations.nixos.PCNX-LeiAle1 = {
    system = "x86_64-linux";
    module = {
      imports = [
        ../../system/PCNX-LeiAle1/configuration.nix
        config.flake.modules.nixos.unfree
        config.flake.modules.nixos.alex
        config.flake.modules.nixos.neovim
        config.flake.modules.nixos.qtile
      ];
    };
  };
}

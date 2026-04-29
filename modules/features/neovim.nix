{ config, ... }:
{
  flake.modules.homeManager.neovim = { config, lib, pkgs, ... }: {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        gcc
        go
        cargo
        nodejs
        python3
        zig
        unzip
        ripgrep
        tree-sitter
      ];
      withPython3 = true;
      withRuby = false;
      initLua = lib.mkForce "";
    };

    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/.config/nvim";

    home = {
      sessionVariables.EDITOR = "nvim";
      packages = with pkgs; [
        neovide
      ];
    };
  };

  flake.modules.nixos.neovim = {
    home-manager.users.alex.imports = [
      config.flake.modules.homeManager.neovim
    ];
  };
}

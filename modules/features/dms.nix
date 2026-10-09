{ config, inputs, lib, ... }:
{
  flake-file.inputs.dank-material-shell = {
    url = lib.mkDefault "github:AvengeMedia/DankMaterialShell/stable";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.homeModules.dms = { config, ... }: {
    # DMS writes its settings into this directory; a store copy would be
    # read-only.
    xdg.configFile."DankMaterialShell".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/configs/hyprland/.config/DankMaterialShell";
  };

  flake.modules.nixos.dms = {
    imports = [ inputs.dank-material-shell.nixosModules.dank-material-shell ];

    programs.dank-material-shell = {
      enable = true;

      # hyprland.lua already runs `dms run` on hyprland.start.
      systemd.enable = false;
    };

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.dms
    ];
  };
}

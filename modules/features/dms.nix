{ inputs, lib, ... }:
{
  flake-file.inputs.dank-material-shell = {
    url = lib.mkDefault "github:AvengeMedia/DankMaterialShell";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.modules.nixos.dms = {
    imports = [ inputs.dank-material-shell.nixosModules.dank-material-shell ];

    programs.dank-material-shell = {
      enable = true;

      # hyprland.lua already runs `dms run` on hyprland.start.
      systemd.enable = false;
    };
  };
}

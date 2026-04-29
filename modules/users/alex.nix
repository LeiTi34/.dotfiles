{ config, inputs, ... }:
{
  flake.modules.homeManager.alex-base = { config, ... }: {
    _module.args = {
      pkgsPath = inputs.nixpkgs-unstable.outPath;
      zen-browser = inputs.zen-browser;
    };

    home.enableNixpkgsReleaseCheck = false;

    nixpkgs = {
      overlays = [ inputs.nurpkgs.overlays.default ];
      config.xdg.configHome = "${config.home.homeDirectory}/.config";
    };

    imports = [
      ../../users/alex/home.nix
    ];
  };

  flake.modules.nixos.alex = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager.users.alex.imports = [
      config.flake.modules.homeManager.alex-base
    ];
  };
}

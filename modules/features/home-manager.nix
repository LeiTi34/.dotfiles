{ lib, config, inputs, ... }:

let
  primaryUser = config.profiles.primaryUser;
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  options.profiles = {
    primaryUser = {
      name = lib.mkOption {
        type = lib.types.str;
      };

      homeDirectory = lib.mkOption {
        type = lib.types.str;
      };

      homeModule = lib.mkOption {
        type = lib.types.deferredModule;
      };
    };

  };

  config = {
    flake.homeModules.base = {
      config,
      ...
    }: {
      _module.args = {
        pkgsPath = inputs.nixpkgs-unstable.outPath;
        zen-browser = inputs.zen-browser;
      };

      home.enableNixpkgsReleaseCheck = false;

      nixpkgs = {
        overlays = [ inputs.nurpkgs.overlays.default ];
        config.xdg.configHome = "${config.home.homeDirectory}/.config";
      };

      imports = [ primaryUser.homeModule ];
    };

    flake.modules.nixos.home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager.users.${primaryUser.name} = {
        imports = [ config.flake.homeModules.base ];

        home = {
          username = primaryUser.name;
          homeDirectory = primaryUser.homeDirectory;
        };
      };
    };
  };
}

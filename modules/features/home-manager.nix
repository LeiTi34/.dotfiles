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

      # Home Manager gets its `pkgs` from nixpkgs-unstable (see `pkgsPath`
      # above) but would otherwise inherit `lib` from the 26.05 system
      # evaluation. `modules/services-modular` imports
      # `${pkgs.path}/lib/services/lib.nix` and passes the ambient `lib` into
      # it, so the two must come from the same nixpkgs.
      home-manager.extraSpecialArgs.lib =
        import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" inputs.nixpkgs-unstable.lib;

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

{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
          };

          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
        };
      }
    );
    default = { };
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    _: { system, module }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ module ];
    }
  ) config.configurations.nixos;
}

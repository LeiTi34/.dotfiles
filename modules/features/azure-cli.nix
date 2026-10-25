{ config, inputs, ... }:
{
  flake.homeModules.azure-cli = { pkgs, ... }: {
    # From nixos-26.05: on nixpkgs-unstable azure-cli doesn't evaluate, its
    # dependency fabric is marked broken with invoke >= 3 (docs/todo.md).
    home.packages = [
      inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.azure-cli
    ];
  };

  flake.modules.nixos.azure-cli = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.azure-cli
    ];
  };
}

{ config, inputs, ... }:
{
  # From the stable channel; Home Manager's pkgs is nixpkgs-unstable.
  flake.homeModules.rustdesk = { pkgs, ... }: {
    home.packages = [ inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.rustdesk ];
  };

  flake.modules.nixos.rustdesk = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.rustdesk
    ];
  };
}

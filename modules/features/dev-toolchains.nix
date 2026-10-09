{ config, ... }:
{
  flake.homeModules.dev-toolchains = { pkgs, ... }: {
    home.packages = with pkgs; [
      devenv
      gnumake
      gcc
      go
      cargo
      nodejs
      pnpm
      php
      php84Packages.composer
      python3
      zig
      uv
    ];
  };

  flake.modules.nixos.dev-toolchains = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.dev-toolchains
    ];
  };
}

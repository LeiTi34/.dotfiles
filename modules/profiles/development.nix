{ config, ... }:
{
  # Editors, toolchains and tools for software development.
  flake.modules.nixos.profile-development = {
    imports = with config.flake.modules.nixos; [
    ];
  };
}

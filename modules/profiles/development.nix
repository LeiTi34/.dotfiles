{ config, ... }:
{
  flake.modules.nixos.profile-development = {
    imports = with config.flake.modules.nixos; [
      neovim
      zed
      dev-toolchains
      direnv
      fnm
      opentofu
      netbird

      herdr
      opencode
      browser-control
    ];
  };
}

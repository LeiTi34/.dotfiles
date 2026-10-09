{ config, ... }:
{
  flake.modules.nixos.profile-development = {
    imports = with config.flake.modules.nixos; [
      neovim
      zed
      dev-toolchains
      fnm
      opentofu

      herdr
      opencode
      browser-control
    ];
  };
}

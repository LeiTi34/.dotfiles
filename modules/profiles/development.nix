{ config, ... }:
{
  flake.modules.nixos.profile-development = {
    imports = with config.flake.modules.nixos; [
      neovim
      zed
      dev-toolchains
      fnm
      opentofu
      pangolin-client

      herdr
      opencode
      browser-control
    ];
  };
}

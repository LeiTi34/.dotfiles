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
      jq

      herdr
      opencode
      browser-control
    ];
  };
}

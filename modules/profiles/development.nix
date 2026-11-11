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
      forgejo-cli

      herdr
      opencode
      browse

      gh
      glab
    ];
  };
}

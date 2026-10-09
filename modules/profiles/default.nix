{ config, ... }:
{
  # The features every host gets.
  flake.modules.nixos.profile-default = {
    imports = with config.flake.modules.nixos; [
    ];
  };
}

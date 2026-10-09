{ config, ... }:
{
  flake.modules.nixos.profile-gaming = {
    imports = with config.flake.modules.nixos; [
      steam
      heroic
      gamescope
      xpadneo
      prismlauncher
      sunshine
    ];
  };
}

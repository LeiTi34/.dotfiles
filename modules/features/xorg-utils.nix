{ ... }:
{
  flake.modules.homeManager.xorg-utils = { pkgs, ... }: {
    home.packages = with pkgs; [
      feh
      brightnessctl
    ];
  };
}

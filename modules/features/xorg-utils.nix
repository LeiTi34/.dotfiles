{ ... }:
{
  flake.homeModules.xorg-utils = { pkgs, ... }: {
    home.packages = with pkgs; [
      feh
      brightnessctl
    ];
  };
}

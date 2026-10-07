{ ... }:
{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      corefonts
      open-sans
      nerd-fonts.fira-code
      nerd-fonts.hack
    ];
  };
}

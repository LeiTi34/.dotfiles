{ ... }:
{
  flake.homeModules.xorg = { pkgs, ... }: {
    home.packages = with pkgs; [
      picom
    ];

    xdg.configFile."picom".source = ../../configs/picom/.config/picom/picom.conf;
  };

  flake.modules.nixos.xorg = {
    services.xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = false;
        startx.enable = true;
      };
    };
  };
}

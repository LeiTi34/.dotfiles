{ config, ... }:
{
  flake.modules.homeManager.qtile = {
    imports = [
      config.flake.modules.homeManager.xorg
      config.flake.modules.homeManager.xorg-utils
    ];

    home.file = {
      ".xinitrc".source = ../../qtile/.xinitrc;
      "startwm.sh".source = ../../qtile/.xinitrc;
      "reconnectwm.sh".source = ../../qtile/.xinitrc;
    };

    xdg.configFile."qtile" = {
      source = ../../qtile/.config/qtile;
      recursive = true;
    };
  };

  flake.modules.nixos.qtile = {
    imports = [
      config.flake.modules.nixos.xorg
    ];

    services.xserver.windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [
        qtile-extras
      ];
    };

    home-manager.users.alex.imports = [
      config.flake.modules.homeManager.qtile
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.qtile = {
    imports = [
      config.flake.homeModules.xorg
      config.flake.homeModules.xorg-utils
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

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.qtile
    ];
  };
}

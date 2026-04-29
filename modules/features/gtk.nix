{ config, ... }:
{
  flake.homeModules.gtk = { config, pkgs, ... }: {
    gtk = {
      enable = true;
      theme = {
        name = "Fluent-Dark";
        package = pkgs.fluent-gtk-theme;
      };
      iconTheme = {
        name = "Fluent-dark";
        package = pkgs.fluent-icon-theme;
      };
      gtk4.theme = config.gtk.theme;
    };

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  flake.modules.nixos.gtk = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.gtk
    ];
  };
}

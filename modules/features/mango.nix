{ config, inputs, lib, ... }:
{
  flake-file.inputs.mangowm = {
    url = lib.mkDefault "github:mangowm/mango";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.homeModules.mango = { pkgs, ... }: {
    home.packages = with pkgs; [
      hyprpolkitagent
      grim
      slurp
      cliphist
      wl-clipboard
      playerctl
      pamixer
      wireplumber
      brightnessctl
      # started and bound in config.conf
      networkmanagerapplet
      bemenu
    ];

    # Linked per file so DMS can write its fragments into ~/.config/mango/dms.
    xdg.configFile."mango" = {
      source = ../../configs/mango/.config/mango;
      recursive = true;
    };
  };

  flake.modules.nixos.mango = { pkgs, ... }: {
    imports = [ inputs.mangowm.nixosModules.mango ];

    programs.mango.enable = true;

    services.udev.packages = [ pkgs.brightnessctl ];

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.mango
    ];
  };
}

{ config, pkgs, ... }:

let
  defaultPkgs = with pkgs; [
    devenv

    gnumake
    alacritty
    ghostty
    librewolf
    libreoffice-fresh
    jetbrains.datagrip
    postgresql_14
    pgadmin4-desktopmode

    lens

    #qtile

    gcc
    go
    cargo
    nodejs
    pnpm
    php
    php84Packages.composer
    python3
    zig
    dig

    unzip
    p7zip

    fortune
    gnupg
    dmenu
    scrot
    # feh

    udiskie
    networkmanagerapplet
    nextcloud-client
    pulsemixer

    element-desktop
    remmina
    pcmanfm
    thunar
    nautilus
    zoom-us

    steam
    protonup-qt
    protontricks
    gamemode
    mangohud

    discord
    obsidian

    seatd
    swayidle
    waylock
    mako
    waybar
    kanshi
    wlr-randr
    foot
    wayvnc
    bemenu
    swaybg
    pavucontrol
    fuzzel

    calc
    chromium
    #postman
    # gimp

    azure-functions-core-tools

    opencode
    claude-code

    opentofu
    uv
  ];
in
{

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # Required for Obsidian
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. this helps avoid breakage when a new home manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home = {
    stateVersion = "25.05"; # Please read the comment before changing.

    packages = defaultPkgs;

    sessionVariables = {
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";
      MOZ_ENABLE_WAYLAND = "0";
    };

    # nixpkgs.config.allowUnfreePredicate = _: true;


    file = {
      ".librewolf/librewolf.overrides.cfg".source = ../../librewolf/.librewolf/librewolf.overrides.cfg;
    };

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
      x11.enable = true;
      gtk.enable = true;
    };
  };

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

  xdg = {
    # portal = {
    #   enable = true;
    #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #   config = {
    #     common = {
    #       default = [
    #         "gtk"
    #       ];
    #       "org.freedesktop.impl.portal.Secret" = [
    #         "gnome-keyring"
    #       ];
    #     };
    #   };
    # };
    #inherit configHome;
    #enable = true;
    configFile = {
      "alacritty" = {
        source = ../../alacritty/.config/alacritty;
        recursive = true;
      };

      "ghostty" = {
        source = ../../ghostty/.config/ghostty;
        recursive = true;
      };

      # "nvim" = {
      #   source = ../../nvim/.config/nvim;
      #   recursive = true;
      # };

      "tridactyl".source = ../../librewolf/.config/tridactyl/tridactylrc;

    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    tmux = {
      enable = true;
    };
    zed-editor.enable = true;
    zathura.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}

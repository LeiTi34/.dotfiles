{ config, pkgs, zen-browser, ... }:

let
  username = "alex";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  defaultPkgs = with pkgs; [
    zen-browser.packages.${stdenv.hostPlatform.system}.default

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

    fd
    ripgrep

    picom
    starship
    nushell
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
    git
    git-lfs
    git-crypt
    gnupg
    ripgrep
    fzf
    xclip
    dmenu
    picom
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
    pwgen
    fastfetch
    # gimp

    azure-functions-core-tools

    opencode
    claude-code

    opentofu
    uv
    sops
    age
    argocd
    kubectl
    kubernetes-helm
    velero
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
    inherit username homeDirectory;
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

      ".xinitrc".source = ../../qtile/.xinitrc;
      "startwm.sh".source = ../../qtile/.xinitrc;
      "reconnectwm.sh".source = ../../qtile/.xinitrc;
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

      "picom".source = ../../picom/.config/picom/picom.conf;

      "qtile" = {
        source = ../../qtile/.config/qtile;
        recursive = true;
      };

      "tridactyl".source = ../../librewolf/.config/tridactyl/tridactylrc;

      "river" = {
        source = ../../river/.config/river;
        recursive = true;
      };
      "waybar" = {
        source = ../../river/.config/waybar;
        recursive = true;
      };
      "kanshi" = {
        source = ../../river/.config/kanshi;
        recursive = true;
      };
    };
  };

  # lets create a target session for river
  systemd.user.targets.river-session = {
    Unit = {
      Description = "River Compositor Session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        line_break.disabled = true;
        character.success_symbol = "[➜](bold green)";
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    pay-respects.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
    home-manager.enable = true;
    htop.enable = true;
    tmux = {
      enable = true;
    };
    zed-editor.enable = true;
    zathura.enable = true;
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      #defaultKeymap = "vicmd";
      initContent = ''
        eval "$(starship init zsh)"

        if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi
      '';
    };
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
            email = "a@b.c";
            name = "Alex Leidwein";
        };
        credential = {
          credentialStore = "secretservice";
          helper = "${
            pkgs.git-credential-manager
          }/bin/git-credential-manager";
        #   helper = "${
        #       pkgs.git.override { withLibsecret = true; }
        #     }/bin/git-credential-libsecret";
        };
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}

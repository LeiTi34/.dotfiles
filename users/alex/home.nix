{ config, pkgs, ... }:

let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesDirectory = "${homeDirectory}/.dotfiles/";

  fullPath = path: dotfilesDirectory + path;

  username = "alex";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  defaultPkgs = with pkgs; [
    gnumake
    alacritty
    librewolf
    libreoffice-fresh
    neovide
    #neovim
    jetbrains.datagrip
    postgresql_14
    pgadmin4-desktopmode

    picom
    starship
    nushell
    #qtile

    gcc
    go
    cargo
    nodejs
    nodePackages."@angular/cli"
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
    xfce.thunar
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
    river
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
    neofetch
    gimp
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
    stateVersion = "23.05"; # Please read the comment before changing.

    packages = defaultPkgs;

    sessionVariables = {
      EDITOR = "nvim";
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_STATE_HOME  = "$HOME/.local/state";
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
  };

  xdg = {
    #inherit configHome;
    #enable = true;
    configFile = {
      "alacritty".source = ../../alacritty/.config/alacritty/alacritty.yml;

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

      "nvim".source = mkOutOfStoreSymlink (fullPath "nvim/.config/nvim");

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
    thefuck.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
    home-manager.enable = true;
    htop.enable = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        gcc
        go
        cargo
        nodejs
        python3
        zig

        unzip
        ripgrep
      ];
    };
    zathura.enable = true;
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      #defaultKeymap = "vicmd";
      initExtra = ''
        eval "$(starship init zsh)"

        if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
        fi
      '';
    };
    git = {
      enable = true;
      userEmail = "a@b.c";
      userName = "Alex Leidwein";
      lfs.enable = true;
      extraConfig = {
        credential = {
          credentialStore = "secretservice";
          helper = "${
            pkgs.nur.repos.utybo.git-credential-manager
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

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };

  # # The home.packages option allows you to install Nix packages into your
  # # environment.
  # home.packages = [
  #   pkgs.alacritty
  #   pkgs.nerdfonts
  #   # # Adds the 'hello' command to your environment. It prints a friendly
  #   # # "Hello, world!" when run.
  #   # pkgs.hello
  #
  #   # # It is sometimes useful to fine-tune packages, for example, by applying
  #   # # overrides. You can do that directly here, just don't forget the
  #   # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  #   # # fonts?
  #   # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  #
  #   # # You can also create simple shell scripts directly inside your
  #   # # configuration. For example, this adds a command 'my-hello' to your
  #   # # environment:
  #   # (pkgs.writeShellScriptBin "my-hello" ''
  #   #   echo "Hello, ${config.home.username}!"
  #   # '')
  # ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  #home.file = {
  #  # # Building this configuration will create a copy of 'dotfiles/screenrc' in
  #  # # the Nix store. Activating the configuration will then make '~/.screenrc' a
  #  # # symlink to the Nix store copy.
  #  # ".screenrc".source = dotfiles/screenrc;

  #  # # You can also set the file content immediately.
  #  # ".gradle/gradle.properties".text = ''
  #  #   org.gradle.console=verbose
  #  #   org.gradle.daemon.idletimeout=3600000
  #  # '';
  #};

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alex/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  #home.sessionVariables = {
  #  # EDITOR = "emacs";
  #};

  # Let Home Manager install and manage itself.
}

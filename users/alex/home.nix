{ config, pkgs, ... }:

let
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesDirectory = "${homeDirectory}/.dotfiles/";

  fullPath = path: dotfilesDirectory + path;

  username = "alex";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  defaultPkgs = with pkgs; [
    alacritty
    # librewolf
    #neovim

    picom
    starship
    #qtile

    gcc
    go
    cargo
    nodejs
    python3
    zig

    unzip
    git
    git-crypt
    gnupg
    ripgrep
    fzf
    xclip
    dmenu
    picom
  ];
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
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
    };

    file = {
      ".librewolf/librewolf.overrides.cfg".source = ../../librewolf/.librewolf/librewolf.overrides.cfg;

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
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
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

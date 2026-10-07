{ config, lib, ... }:
let
  version = "1.22.1";
in
{
  # nixpkgs only carries 1.9.1. Adapted from upstream's packaging/nix/default.nix.in.
  # Not wrapped with hyprland: hyprctl must come from the system Hyprland so its
  # IPC version matches the running compositor.
  flake.homeModules.hyprmoncfg =
    { config, pkgs, ... }:
    let
      hyprmoncfg = pkgs.buildGoModule {
        pname = "hyprmoncfg";
        inherit version;

        src = pkgs.fetchFromGitHub {
          owner = "crmne";
          repo = "hyprmoncfg";
          tag = "v${version}";
          hash = "sha256-G7H/xPfmAcrvyHID95UM9hTBAw5UHSFh3NEJjpsb+sQ=";
        };

        vendorHash = "sha256-gQbjvdKtO0hCXrs9RnWo1s0YeHf5W9t+8AgS2ELXlPo=";

        subPackages = [
          "cmd/hyprmoncfg"
          "cmd/hyprmoncfgd"
        ];

        env.CGO_ENABLED = 0;

        ldflags = [
          "-s"
          "-w"
          "-X github.com/crmne/hyprmoncfg/internal/buildinfo.Version=${version}"
        ];

        # The test suite needs Hyprland and shell-script fixtures.
        doCheck = false;

        postInstall = ''
          install -Dm644 packaging/applications/hyprmoncfg.desktop \
            $out/share/applications/hyprmoncfg.desktop
          install -Dm644 packaging/icons/hyprmoncfg.svg \
            $out/share/icons/hicolor/scalable/apps/hyprmoncfg.svg
        '';

        meta = {
          description = "Terminal-first monitor configurator and auto-switching daemon for Hyprland";
          homepage = "https://github.com/crmne/hyprmoncfg";
          license = lib.licenses.mit;
          mainProgram = "hyprmoncfg";
        };
      };
    in
    {
      home.packages = [ hyprmoncfg ];

      systemd.user.services.hyprmoncfgd = {
        Unit = {
          Description = "Hyprland monitor profile daemon (hyprmoncfgd)";
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${hyprmoncfg}/bin/hyprmoncfgd";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "default.target" ];
      };

      # hyprmoncfg follows symlinks and writes the generated rules back into
      # the repo; a store copy would be read-only.
      xdg.configFile."hypr/hyprmoncfg-monitors.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland/.config/hypr/hyprmoncfg-monitors.lua";
    };

  flake.modules.nixos.hyprmoncfg = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.hyprmoncfg
    ];
  };
}

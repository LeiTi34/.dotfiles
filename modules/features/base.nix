{ config, ... }:
let
  primaryUser = config.profiles.primaryUser.name;
in
{
  flake.modules.nixos.base = { pkgs, ... }: {
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "root" primaryUser ];
      };

      optimise = {
        automatic = true;
        dates = [ "04:00" ];
      };

      gc = {
        automatic = true;
        dates = "03:00";
        options = "--delete-older-than 30d";
      };
    };

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Vienna";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "de";
    };
    services.xserver.xkb.layout = "de";

    zramSwap = {
      enable = true;
      memoryPercent = 25;
      memoryMax = 68719476736;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.dbus.enable = true;

    security.sudo.wheelNeedsPassword = false;

    users = {
      defaultUserShell = pkgs.zsh;
      users.${primaryUser} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "input"
          "power"
          "video"
          "optical"
          "network"
          "storage"
          "kvm"
          "audio"
        ];
        packages = [ pkgs.tree ];
      };
    };

    programs = {
      zsh.enable = true;
      dconf.enable = true;

      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc.lib
          zlib # often needed by other Python packages
        ];
      };

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    environment.systemPackages = with pkgs; [
      wget
      git
      htop
    ];
  };
}

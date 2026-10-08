{ config, ... }:
{
  configurations.nixos."840G6" = {
    system = "x86_64-linux";
    module = {
      imports = with config.flake.modules.nixos; [
        ../../system/840G6/configuration.nix
        workstation
        laptop
        fwupd
        secure-boot
        measured-boot
        bluetooth
        snapper
        android
        headsetcontrol
        hyprmoncfg
        vpn
        fonts-extra
        xdg-user-dirs
        thunderbird
        spellcheck
        gimp
        feh
        rustdesk
        postman
        gh
        glab
        azure-cli
        azd
        colmena
        btdu
        zip
        rsync
        net-tools
        traceroute
        whois
      ];
    };
  };
}

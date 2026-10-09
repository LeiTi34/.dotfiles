{ config, ... }:
{
  configurations.nixos."840G6" = {
    system = "x86_64-linux";
    # Host-specific settings: modules/hosts/840G6/*.nix
    module = {
      imports = with config.flake.modules.nixos; [
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

{ config, ... }:
{
  configurations.nixos."LTNX-LeiAle1" = {
    system = "x86_64-linux";
    # Host-specific settings: modules/hosts/LTNX-LeiAle1/*.nix
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
        rsync
        net-tools
        traceroute
        whois
      ];
    };
  };
}

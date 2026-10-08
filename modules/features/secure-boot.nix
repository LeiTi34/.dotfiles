{ inputs, lib, ... }:
{
  flake-file.inputs.lanzaboote = {
    url = lib.mkDefault "github:nix-community/lanzaboote/v1.1.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Keys are created/enrolled with sbctl and live in /var/lib/sbctl (not in
  # this repo); see docs/secure-boot.md.
  flake.modules.nixos.secure-boot =
    { config, lib, pkgs, ... }:
    let
      fwupdEfiDir = "${config.services.fwupd.package.fwupd-efi}/libexec/fwupd/efi";
    in
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      environment.systemPackages = [ pkgs.sbctl ];

      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        # No editing of boot entries (e.g. init=/bin/sh) at the boot menu.
        settings.editor = false;
      };

      # With Secure Boot on, fwupd only uses fwupdx64.efi.signed from the
      # (read-only) fwupd-efi package directory. Sign it with our db key and
      # overlay the result onto that directory inside the fwupd service.
      # lanzaboote's own fwupd-efi unit relies on FWUPD_EFIAPPDIR, which
      # fwupd 2.x no longer reads, so it is replaced.
      systemd.services.fwupd-efi.enable = false;

      systemd.services.fwupd-efi-sign = lib.mkIf config.services.fwupd.enable {
        description = "Sign fwupd's EFI binary for Secure Boot";
        wantedBy = [ "fwupd.service" ];
        before = [ "fwupd.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "fwupd-efi";
        };
        path = [ pkgs.sbctl ];
        script = ''
          install -m 644 ${fwupdEfiDir}/fwupdx64.efi /var/lib/fwupd-efi/fwupdx64.efi
          # sbctl skips an output that is already signed, even if outdated.
          rm -f /var/lib/fwupd-efi/fwupdx64.efi.signed
          sbctl sign -o /var/lib/fwupd-efi/fwupdx64.efi.signed ${fwupdEfiDir}/fwupdx64.efi
        '';
      };

      systemd.services.fwupd.serviceConfig.BindReadOnlyPaths = lib.mkIf config.services.fwupd.enable [
        "/var/lib/fwupd-efi:${fwupdEfiDir}"
      ];
    };
}

{ ... }:
{
  # TPM2 unlock bound to a systemd-pcrlock policy that lanzaboote keeps up to
  # date (firmware, boot chain, Secure Boot state). Needs the secure-boot
  # feature; the LUKS enrollment is a manual step, see docs/secure-boot.md.
  flake.modules.nixos.measured-boot = {
    boot.initrd.systemd = {
      enable = true;
      tpm2.enable = true;
    };

    boot.lanzaboote.measuredBoot = {
      enable = true;
      pcrs = [
        0
        4
        7
      ];
    };
  };
}

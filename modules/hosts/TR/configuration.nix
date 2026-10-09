{ ... }:
{
  configurations.nixos.TR.module = {
    networking.hostName = "TR";

    boot.loader = {
      systemd-boot.enable = true;
      # The ESP is 1 GiB and also holds Arch's kernels.
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    # The firmware announces a TPM2 (AMD fTPM) that tpm_crb can't claim
    # ("ACPI region does not cover the entire command/response buffer",
    # -EBUSY), so /dev/tpmrm0 never shows up and tpm2.target waits 90 s.
    boot.kernelParams = [ "systemd.tpm2_wait=0" ];

    # AX210 Wi-Fi/Bluetooth firmware
    hardware.enableRedistributableFirmware = true;
    zramSwap.enable = true;

    system.stateVersion = "26.05";
  };
}

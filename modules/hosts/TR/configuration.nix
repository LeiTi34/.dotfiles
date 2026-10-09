{ ... }:
{
  configurations.nixos.TR.module = {
    networking.hostName = "TR";

    boot.loader = {
      systemd-boot.enable = true;
      # The ESP is 1 GiB.
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    # The fTPM is off in the BIOS (Security Device Support): with BIOS A.89
    # tpm_crb can't claim it ("ACPI region does not cover the entire
    # command/response buffer", -EBUSY), and systemd then waits 90 s for
    # /dev/tpmrm0 on every boot.

    # AX210 Wi-Fi/Bluetooth firmware
    hardware.enableRedistributableFirmware = true;
    zramSwap.enable = true;

    system.stateVersion = "26.05";
  };
}

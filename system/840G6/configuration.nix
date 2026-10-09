{ lib, pkgs, ... }:
let
  # Was off during dual boot: a hibernated Arch and a booted NixOS (or the
  # other way around) would corrupt the shared btrfs. Arch keeps its
  # hibernate targets masked; never boot Arch while NixOS is hibernated.
  hibernation = true;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "840G6";

  boot = {
    loader.efi.canTouchEfiVariables = true;
    # Secure Boot via lanzaboote (feature secure-boot) replaces systemd-boot.
    # Each generation with a new kernel takes ~55 MB of the 1 GiB ESP.
    lanzaboote.configurationLimit = 8;

    initrd.systemd.enable = true;

    blacklistedKernelModules = [ "pcspkr" ];

    resumeDevice = lib.mkIf hibernation "/dev/mapper/cryptroot";
    kernelParams = lib.optionals hibernation [
      # btrfs inspect-internal map-swapfile -r /swap/swapfile
      "resume_offset=24751"
      # BIOS 01.06.02 overwrites the firmware copy of the DSDT across
      # hibernation ("DSDT has been corrupted or replaced", \_WAK aborts,
      # lid/AC/dock unreadable afterwards). Keep a copy in kernel memory.
      "acpi=copy_dsdt"
    ];
  };

  swapDevices = lib.optional hibernation { device = "/swap/swapfile"; };

  # The LUKS passphrase and TPM PIN are typed with the German layout.
  console.earlySetup = true;
  # TPM2 + PIN (feature measured-boot); the passphrase keeps working.
  boot.initrd.luks.devices.cryptroot.crypttabExtraOpts = [ "tpm2-device=auto" ];

  # BE200 Bluetooth (btintel_pcie) misses D3/D0 doorbell interrupts, which
  # breaks suspend/hibernate (-EBUSY, then a hang). Unload it around sleep.
  powerManagement = {
    powerDownCommands = "${pkgs.kmod}/bin/modprobe -r btintel_pcie";
    resumeCommands = "${pkgs.kmod}/bin/modprobe btintel_pcie";
  };

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
    intel-compute-runtime
  ];

  networking.hosts = {
    "192.168.0.11" = [ "portainer.leidwein.com" ];
    "192.168.67.11" = [ "PCNX-LeiAle1" ];
  };

  hardware.printers.ensurePrinters = [
    {
      name = "HP_LaserJet_400_MFP_M425dn";
      description = "HP LaserJet 400 MFP M425dn";
      deviceUri = "socket://10.0.0.93";
      model = "drv:///sample.drv/laserjet.ppd";
      ppdOptions.PageSize = "A4";
    }
  ];

  # Same ids as on Arch, so file ownership in the shared /home matches.
  users.users.alex = {
    uid = 1000;
    group = "alex";
  };
  users.groups.alex.gid = 1000;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Before changing this value read the
  # documentation for this option (e.g. man configuration.nix).
  system.stateVersion = "26.05";
}

{ ... }:
{
  # Based on `nixos-generate-config --show-hardware-config --no-filesystems`.
  # One btrfs over both NVMe drives (label ROOT, data single); subvolumes at
  # the top level: nixos (/, with nested nix), home.
  configurations.nixos.TR.module =
    { config, lib, modulesPath, ... }:
    let
      btrfs = subvol: {
        device = "/dev/disk/by-label/ROOT";
        fsType = "btrfs";
        options = [ "subvol=${subvol}" "noatime" "compress=zstd" ];
      };
    in
    {
      imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

      boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = btrfs "nixos";
      fileSystems."/home" = btrfs "home";

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}

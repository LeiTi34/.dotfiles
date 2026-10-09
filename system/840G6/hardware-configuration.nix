# Based on `nixos-generate-config --show-hardware-config --no-filesystems`.
# Subvolumes at the top level: nixos (/, with nested nix and var/lib/docker),
# home, swap.
{ config, lib, modulesPath, ... }:

let
  btrfs = subvol: {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=${subvol}" "noatime" "compress=zstd" ];
  };
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices.cryptroot.device =
    "/dev/disk/by-uuid/b069ecd0-28ee-49b0-ac7b-ed03b05916ab";

  # nix and var/lib/docker are subvolumes nested in `nixos`, mounted with it.
  fileSystems."/" = btrfs "nixos";
  fileSystems."/home" = btrfs "home";
  fileSystems."/swap" = btrfs "swap";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FE95-33D4";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

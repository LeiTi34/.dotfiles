# TR: Arch → NixOS

Plan for reinstalling TR (desktop, Arch) as NixOS host `TR` while keeping
`/home`. Arch stays bootable as a fallback until NixOS has proven itself.
Progress: `docs/todo.md` ("TR to NixOS").

## The machine

| | |
|---|---|
| Board | MSI X399 SLI PLUS (MS-7B09), UEFI (AMI), Secure Boot reported as enabled but not enforced: the unsigned systemd-boot and kernels boot |
| CPU | AMD Ryzen Threadripper 2920X (12C/24T), `kvm-amd`, `amd-ucode` |
| RAM | 32 GiB |
| GPU | AMD Radeon RX 7900 (Navi 31), `amdgpu` |
| Network | Intel I211 (`igb`, wired, in use), Intel AX210 Wi-Fi 6E + Bluetooth (`iwlwifi`, `btusb`) |
| Audio | Realtek ALC1220 (`snd_hda_intel`) |
| Storage | two NVMe (Phison E12 ~1 TB, ADATA SX8200 Pro ~1 TB); SATA (`ahci`) and USB (`xhci_pci`) controllers present |
| Monitors | Samsung LC27G5xT 2560x1440@144 (DP-3, right, primary), BenQ 1920x1080@60 (HDMI-1, left) |
| Locale | German keymap, Europe/Vienna (matches `base`) |
| User | `alex` with uid/gid 1000 and group `alex` (matches `modules/users/alex.nix`) |

### Disks

```
nvme0n1p1  1 GiB    vfat   BOOT   /boot (ESP, 92 MB used)
nvme0n1p2  930 GiB  btrfs  ROOT ┐ one filesystem over both drives,
nvme1n1p1  954 GiB  btrfs  ROOT ┘ data `single`, metadata DUP
```

Subvolumes (all nested in `arch/root`, which is `/`): `home`, `var`, `tmp`,
`etc`, `swap` (33 GiB swapfile). Nothing at the top level besides `arch`.

1.77 of 1.84 TiB are used, and **all space is allocated to chunks** (2 MiB
unallocated, metadata 6.1 of 8 GiB): the filesystem can run into ENOSPC for
metadata even with free data space. Free space and balance first (phase 0).

- `/home/alex` 1.7 TiB: Steam 1.2 TiB (81 games, can be redownloaded),
  Games 149 GiB, Nextcloud 103 GiB, Minecraft, LM Studio models, VirtualBox
  VMs, project folders, `~/git` 13 GiB.
- `/var` 88 GiB, of which 81 GiB pacman cache.

Data `single` over two drives means one dead drive loses the filesystem;
with 1.76 TiB of data it can't become RAID1. Everything worth keeping must
be in git or Nextcloud.

### What runs on Arch

GDM with GNOME (current session), Hyprland and DMS installed as well.
Services: NetworkManager, bluetooth, sshd, lm_sensors, gamemoded, PipeWire.
Gaming: Steam, protontricks, protonup, gamescope, mangohud, Lutris, Heroic,
Minecraft launcher, r2modman, Wine, xpadneo (Xbox controller driver), Apollo
(game streaming). Tools: headsetcontrol, msi-rgb, amdgpu_top, radeontop.

## Target

- `modules/hosts/TR.nix`: `profile-default`, `profile-development`,
  `profile-gaming`, plus `gnome`, `bluetooth`, `headsetcontrol`.
- New feature `gnome`: GNOME with GDM as login manager. GDM also offers
  the Hyprland session.
- Subvolumes like LTNX-LeiAle1: `nixos` (`/`, with `nix` nested),
  `home` (a snapshot of Arch's home). Swap via zram, no swapfile.
- systemd-boot next to Arch's entries on the same ESP. No lanzaboote: the
  firmware doesn't enforce Secure Boot.

Open decisions (no feature yet): Lutris, Heroic, gamescope, Minecraft
launcher (Prism?), xpadneo (`hardware.xpadneo.enable`), Apollo/Sunshine,
msi-rgb/OpenRGB, `avahi`.

## Phase 0: on Arch

1. **Check the data.** Everything not in git or Nextcloud is at risk:
   ```sh
   # repos with uncommitted or unpushed work
   for d in ~/git/*/ ~/git/*/*/; do
     [ -e "$d/.git" ] || continue
     s=$(git -C "$d" status --porcelain -b | grep -E '^\?\?|^ ?[MADRU]|ahead')
     [ -n "$s" ] && echo "$d"
   done
   ```
   Copy anything else that matters (project folders, Minecraft worlds,
   `mc-server`, VMs, `Desktop`, `Downloads`) into Nextcloud or an external
   disk, and let the Nextcloud client finish syncing.
2. **Free space and unallocated chunks:**
   ```sh
   sudo pacman -Scc                       # 81 GiB package cache
   rm -rf ~/.local/share/Trash/*          # 5 GiB
   sudo btrfs balance start -dusage=10 /  # repeat with 25, 50 until
   sudo btrfs filesystem usage -T /       # "Unallocated" is > 30 GiB
   ```
   Uninstall games you won't play again (Steam) if it stays tight. NixOS
   needs ~30–50 GiB for `/nix`, and the home snapshot grows with every
   change on either side.
3. **Note the current state** (lands in the home snapshot):
   ```sh
   pacman -Qeq > ~/arch-packages.txt
   systemctl list-unit-files --state=enabled > ~/arch-services.txt
   ```
4. **Repo:** `~/.dotfiles` is a colocated jj repo. The uncommitted changes
   from TR are commit "wip(TR): uncommitted changes from TR" on top of the old
   `master`; `~/.dotfiles.pre-jj` is the copy before colocating, the git
   stashes are still in `git stash list`. Move to the current layout with
   `docs/configs-migration.md` steps 1 and 2b (restow keeps Arch usable as
   the fallback):
   ```sh
   cd ~/.dotfiles
   jj git fetch && jj bookmark track master@origin && jj new master
   ```
   Then the leftover-file move and the restow from that doc.
5. **Repo, on another machine:** add the host (phase 1), validate, push.
6. **Installer:** NixOS 26.05 minimal ISO on a USB stick. If it doesn't
   boot, switch Secure Boot off in the BIOS.

## Phase 1: the host in the repo

`modules/hosts/TR.nix`:

```nix
{ config, ... }:
{
  configurations.nixos.TR = {
    system = "x86_64-linux";
    # Host-specific settings: modules/hosts/TR/*.nix
    module = {
      imports = with config.flake.modules.nixos; [
        profile-default
        profile-development
        profile-gaming
        gnome
        bluetooth
        headsetcontrol
      ];
    };
  };
}
```

`modules/hosts/TR/hardware-configuration.nix` (check against
`nixos-generate-config --show-hardware-config --no-filesystems` from the
installer):

```nix
{ ... }:
{
  # Based on `nixos-generate-config --show-hardware-config --no-filesystems`.
  # One btrfs over both NVMe drives (label ROOT, data single); subvolumes at
  # the top level: nixos (/, with nested nix), home. Arch lives in `arch`
  # until it's removed.
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
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      boot.kernelModules = [ "kvm-amd" ];

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
```

`modules/hosts/TR/configuration.nix`:

```nix
{ ... }:
{
  configurations.nixos.TR.module = {
    networking.hostName = "TR";

    boot.loader = {
      systemd-boot.enable = true;
      # The ESP is 1 GiB and still holds Arch's kernels.
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    # AX210 Wi-Fi/Bluetooth firmware
    hardware.enableRedistributableFirmware = true;
    zramSwap.enable = true;

    system.stateVersion = "26.05";
  };
}
```

`modules/hosts/TR/hyprland.nix` and `monitors.lua`, like PCNX-LeiAle1 (the
monitor lines from the "wip(TR)" commit's `hyprland.lua` move here; the
shared `hyprland.lua` stays without monitors):

```nix
{ config, ... }:
{
  configurations.nixos.TR.module = {
    home-manager.users.${config.profiles.primaryUser.name}.xdg.configFile."hypr/monitors.lua".source =
      ./monitors.lua;
  };
}
```

```lua
---@module 'hl'

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "DP-3",
    mode     = "2560x1440@144",
    position = "1920x0",
    scale    = 1,
    vrr      = 3,
})
```

Check the connector names with `hyprctl monitors` after the first login;
GNOME's `monitors.xml` has seen them as DP-2/DP-3 and HDMI-0/HDMI-1.

`modules/features/gnome.nix`:

```nix
{ ... }:
{
  flake.modules.nixos.gnome = {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    # SSH keys come from rbw (bitwarden feature); GNOME would set
    # SSH_AUTH_SOCK to its own agent.
    services.gnome.gcr-ssh-agent.enable = false;
  };
}
```

Validate with `nix flake check --no-build` and make sure the toplevels of
LTNX-LeiAle1 and PCNX-LeiAle1 didn't change.

## Phase 2: install

From the installer (as root):

1. Subvolumes. The home snapshot shares all data with Arch's home, so it
   costs no space until one side changes:
   ```sh
   mkdir /top && mount -o subvolid=5 /dev/disk/by-label/ROOT /top
   btrfs subvolume create /top/nixos
   btrfs subvolume create /top/nixos/nix
   btrfs subvolume snapshot /top/arch/root/home /top/home
   ```
2. Mount the target:
   ```sh
   mount -o subvol=nixos,noatime,compress=zstd /dev/disk/by-label/ROOT /mnt
   mkdir -p /mnt/home /mnt/boot
   mount -o subvol=home,noatime,compress=zstd /dev/disk/by-label/ROOT /mnt/home
   mount -o fmask=0077,dmask=0077 /dev/disk/by-label/BOOT /mnt/boot
   ```
3. Keep TR's SSH identity and root's key:
   ```sh
   mkdir -p /mnt/etc/ssh /mnt/root/.ssh
   cp -a /top/arch/root/etc/ssh/ssh_host_* /mnt/etc/ssh/
   cp -a /top/arch/root/root/.ssh/authorized_keys /mnt/root/.ssh/
   ```
4. Compare the hardware config with the one in the repo; fix the repo if
   needed (and push again):
   ```sh
   nixos-generate-config --root /mnt --show-hardware-config --no-filesystems
   ```
5. Build on another NixOS machine and copy the result over, because the
   flake has a private input (fetched over SSH with the work key) that the
   installer can't reach. On the installer `passwd` (for SSH), then on the
   build machine:
   ```sh
   sys=$(nix build --no-link --print-out-paths .#nixosConfigurations.TR.config.system.build.toplevel)
   nix copy --no-check-sigs --to "ssh://root@<installer-ip>?remote-store=local?root=/mnt" "$sys"
   echo "$sys"
   ```
   Back on the installer:
   ```sh
   nixos-install --system <the printed path> --no-root-passwd
   nixos-enter --root /mnt -c 'passwd alex'
   ```
   `nixos-install` writes its systemd-boot and `loader.conf` to the ESP;
   Arch's entries in `/boot/loader/entries/` stay and remain selectable.
6. Reboot into NixOS (GDM).

## Phase 3: first boot

1. Log in to GNOME, check network, sound, Bluetooth, both monitors.
2. Links from the Arch stow setup in the home snapshot: list and delete
   (`docs/configs-migration.md` step 2a.1). Files Home Manager wants to
   replace are moved to `*.pre-hm`.
3. rbw: set up both profiles as on the other hosts, including
   `rbw config set pinentry rbw-pinentry-keyring`, then check `ssh-add -l`.
4. Rebuilds: `nixos-rebuild switch --flake .#TR --sudo` on TR (needs the work
   vault for the private input), or from another host with
   `--target-host root@TR`.
5. Steam: the library in `~/.local/share/Steam` is kept; reinstall Proton-GE
   versions with protonup-qt if games miss them. Start a few games.
6. Hyprland via GDM: session works, `monitors.lua` matches.
7. Port the "wip(TR)" changes worth keeping (nvim treesitter rewrite, DMS
   settings, opencode) into `configs/`, then abandon that commit.
8. Tick TR off in `docs/todo.md` ("configs/ migration").

## Phase 4: remove Arch

After a few weeks without needing the fallback:

```sh
sudo mount -o subvolid=5 /dev/disk/by-label/ROOT /mnt
sudo btrfs subvolume delete /mnt/arch/root/{home,var,tmp,etc,swap}
sudo btrfs subvolume delete /mnt/arch/root /mnt/arch
sudo umount /mnt
sudo rm /boot/loader/entries/arch*.conf /boot/vmlinuz-* /boot/initramfs-* /boot/amd-ucode.img
```

Afterwards delete `~/.dotfiles.pre-jj`, this doc, its line in the README
table and the todo section.

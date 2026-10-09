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

Host `TR` (`modules/hosts/TR.nix`, `modules/hosts/TR/`):

- `profile-default`, `profile-development`, `profile-gaming`, `gnome` (GNOME
  with GDM, which also offers the Hyprland session), `bluetooth`,
  `headsetcontrol`, `openrgb`.
- Subvolumes like LTNX-LeiAle1: `nixos` (`/`, with `nix` nested),
  `home` (a snapshot of Arch's home). Swap via zram, no swapfile.
- systemd-boot next to Arch's entries on the same ESP. No lanzaboote: the
  firmware doesn't enforce Secure Boot.
- `systemd.tpm2_wait=0`: the firmware announces an fTPM the kernel can't
  claim, systemd would wait 90 s for it on every boot (on Arch:
  `dev-tpmrm0.device` and `tpm2.target` masked).

Replacements for Arch packages:

| Arch | NixOS |
|---|---|
| minecraft-launcher (not in nixpkgs) | `prismlauncher`; log in with the Microsoft account, import worlds from `~/.minecraft` |
| apollo (not in nixpkgs) | `sunshine`; same `~/.config/sunshine`, so pairings and apps carry over; not autostarted (Apollo was disabled) |
| msi-rgb (not in nixpkgs) | `openrgb` |

## Phase 0: on Arch

Done:

- Space: games uninstalled, 260 GiB unallocated.
- `~/arch-packages.txt`, `~/arch-packages-aur.txt`, `~/arch-services.txt`,
  `~/arch-user-services.txt`: what Arch had installed and enabled.
- `~/.dotfiles` is a colocated jj repo on the current `master` in the
  `configs/` layout, restowed (`docs/configs-migration.md`), so Arch stays
  usable as the fallback. The uncommitted changes TR had are the commit
  "wip(TR): uncommitted changes from TR" on top of the old `master`;
  `~/.dotfiles.pre-jj` is the copy before colocating, the old git stashes
  are still in `git stash list`.
- Nix from pacman (`nix`, no daemon; everything below runs as root).

## Phase 1: the host in the repo

Done: host `TR` and the features it needs are in the repo and pushed. The
hardware config is based on the scan; step 5 of phase 2 compares it with
`nixos-generate-config`.

## Phase 2: install from Arch

No installer: Arch keeps running, NixOS is installed into new subvolumes
mounted at `/mnt/nixos` ("Installing from another Linux distribution" in the
NixOS manual). As root on TR unless noted:

1. Log out of GNOME, so the home snapshot doesn't catch open browser
   profiles or the Nextcloud database mid-write.
2. Subvolumes. The home snapshot shares all data with Arch's home, so it
   costs no space until one side changes:
   ```sh
   mkdir -p /mnt/top && mount -o subvolid=5 LABEL=ROOT /mnt/top
   btrfs subvolume create /mnt/top/nixos
   btrfs subvolume create /mnt/top/nixos/nix
   btrfs subvolume snapshot /mnt/top/arch/root/home /mnt/top/home
   ```
3. Mount the target:
   ```sh
   mkdir -p /mnt/nixos
   mount -o subvol=nixos,noatime,compress=zstd LABEL=ROOT /mnt/nixos
   mkdir -p /mnt/nixos/home /mnt/nixos/boot
   mount -o subvol=home,noatime,compress=zstd LABEL=ROOT /mnt/nixos/home
   mount -o fmask=0077,dmask=0077 LABEL=BOOT /mnt/nixos/boot
   ```
4. Keep TR's SSH identity and root's key, and drop the stow links from the
   home snapshot (Home Manager links these programs itself):
   ```sh
   mkdir -p /mnt/nixos/etc/ssh /mnt/nixos/root/.ssh
   cp -a /etc/ssh/ssh_host_* /mnt/nixos/etc/ssh/
   cp -a /root/.ssh/authorized_keys /mnt/nixos/root/.ssh/
   find /mnt/nixos/home/alex -maxdepth 4 -xdev -path '*/.cache' -prune -o \
     -type l -lname '*dotfiles*' -print -exec rm -- {} +
   ```
5. Compare the hardware config with `modules/hosts/TR/hardware-configuration.nix`;
   fix the repo if needed (and push again):
   ```sh
   nix --extra-experimental-features 'nix-command flakes' shell \
     github:NixOS/nixpkgs/nixos-26.05#nixos-install-tools -c \
     nixos-generate-config --root /mnt/nixos --show-hardware-config --no-filesystems
   ```
6. On another NixOS machine, build and copy the system into TR's new store;
   the flake has a private input (fetched over SSH with the work key) that
   TR can't reach yet:
   ```sh
   sys=$(nix build --no-link --print-out-paths .#nixosConfigurations.TR.config.system.build.toplevel)
   nix copy --no-check-sigs --to "ssh://root@TR?remote-store=local?root=/mnt/nixos" "$sys"
   echo "$sys"
   ```
7. Install, and give alex the same password as on Arch:
   ```sh
   nix --extra-experimental-features 'nix-command flakes' shell \
     github:NixOS/nixpkgs/nixos-26.05#nixos-install-tools -c sh -c '
       nixos-install --root /mnt/nixos --system <the printed path> --no-root-passwd --no-channel-copy
       grep "^alex:" /etc/shadow | cut -d: -f1,2 | nixos-enter --root /mnt/nixos -c "chpasswd -e"'
   ```
   `nixos-install` writes its systemd-boot and `loader.conf` (default:
   NixOS) to the ESP; Arch's entries in `/boot/loader/entries/` stay and
   remain selectable.
8. `umount -R /mnt/nixos /mnt/top`, reboot into NixOS (GDM).

## Phase 3: first boot

1. Log in to GNOME, check network, sound, Bluetooth, both monitors.
2. Files Home Manager wanted to replace were moved to `*.pre-hm`; check
   and delete them.
3. rbw: set up both profiles as on the other hosts, including
   `rbw config set pinentry rbw-pinentry-keyring`, then check `ssh-add -l`.
4. Rebuilds: `nixos-rebuild switch --flake .#TR --sudo` on TR (needs the work
   vault for the private input), or from another host with
   `--target-host root@TR`.
5. Steam: the library in `~/.local/share/Steam` is kept; reinstall Proton-GE
   versions with protonup-qt if games miss them. Start a few games.
6. Hyprland via GDM: session works, `modules/hosts/TR/monitors.lua`
   matches (`hyprctl monitors`; GNOME's `monitors.xml` has seen the
   outputs as DP-2/DP-3 and HDMI-0/HDMI-1).
7. OpenRGB detects the mainboard (`openrgb --list-devices`), Sunshine
   starts (`systemctl --user start sunshine`), the controller pairs
   (xpadneo).
8. Port the "wip(TR)" changes worth keeping (nvim treesitter rewrite, DMS
   settings, opencode) into `configs/`, then abandon that commit.

## Phase 4: remove Arch

After a few weeks without needing the fallback:

```sh
sudo mount -o subvolid=5 /dev/disk/by-label/ROOT /mnt
sudo btrfs subvolume delete /mnt/arch/root/{home,var,tmp,etc,swap}
sudo btrfs subvolume delete /mnt/arch/root /mnt/arch
sudo umount /mnt
sudo rm /boot/loader/entries/arch*.conf /boot/vmlinuz-* /boot/initramfs-* /boot/amd-ucode.img
```

Afterwards remove nix's leftovers from Arch with it (`/nix` lived in
`arch/root`), delete `~/.dotfiles.pre-jj`, this doc, its line in the README
table and the todo section.

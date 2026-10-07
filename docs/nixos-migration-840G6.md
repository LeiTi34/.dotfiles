# Migrating 840G6 from Arch to NixOS

Goal: install NixOS next to Arch, switch to NixOS as the daily system, remove
dual boot, keep Arch as a read-only subvolume for a while, then delete it.
No user data may be lost at any step.

## Current state

| | |
|---|---|
| Hardware | HP EliteBook 8 G1i, Core Ultra 7 258V (Lunar Lake), Arc 140V, BE200 Wi-Fi, SOF audio, Thunderbolt |
| Disk | `nvme0n1p1` ESP, 1 GiB, label `BOOT`, UUID `FE95-33D4` (~200 MiB used) |
| | `nvme0n1p2` LUKS, label `CRYPTROOT`, UUID `b069ecd0-28ee-49b0-ac7b-ed03b05916ab`, mapped as `cryptroot` |
| Filesystem | btrfs, label `ROOT`, ~720 GiB used / ~210 GiB free |
| Arch root | Installed directly in the top-level subvolume (`subvol=/`, id 5) |
| Nested subvolumes | `home` (with nested `home/.snapshots`, `home/alex/VirtualBox VMs`, `home/alex/Nextcloud2`), `swap`, `etc` (with `etc/.snapshots`), `.snapshots`, `tmp`, `var/tmp`, `var/log`, `var/cache/pacman/pkg`, `var/abs`, `srv`, `var/lib/machines`, `var/lib/portables`, Docker image subvolumes under `var/lib/docker/btrfs/subvolumes` (see [840G6-inventory.md](840G6-inventory.md)) |
| Swap | `/swap/swapfile` (32 GiB, `resume_offset=24751`) + zram |
| Boot | systemd-boot, entries `arch`, `arch-lts`, `arch-zen`; Secure Boot off, sbctl keys present |
| Initramfs | mkinitcpio `encrypt` hook, `cryptdevice=LABEL=CRYPTROOT:cryptroot` |
| Locale | `de_AT.UTF-8`, console keymap `de-latin1`, font `ter-124b` |
| User | `alex`, uid 1000, gid 1000 |

Data outside `/home` that must survive:

- Docker volumes (farmtracker Postgres/MariaDB, langfuse, mysql, ...)
- `/etc`: NetworkManager connections (Wi-Fi, VPN), cups printers/PPDs, ssh
  host keys, config to port (see [840G6-inventory.md](840G6-inventory.md))
- `/var/lib/{bluetooth,sbctl}`
- `/usr/local/bin/sleep-on-unplug`, Caddy local CA in `/root/.local/share/caddy`

Secrets currently stored in plain text on Arch (`/etc/environment`, CIFS
credentials in `/etc/fstab`) must not end up in this public repo. Move them to
rbw or sops when porting.

## Subvolume layout

Subvolumes use plain names, following the existing scheme (`home`, `swap`,
`etc`, ...). While Arch still occupies the top level, a top-level `nix`
subvolume would collide with Arch's `/nix` directory, so NixOS's store and
Docker data are nested inside the `nixos` subvolume, the same way Arch nests
`etc` and `var/lib/machines`. Nested subvolumes appear automatically when the
parent is mounted and are excluded from snapshots of the parent.

`/home` is shared between Arch and NixOS from the first NixOS boot. Read-only
snapshots taken right before the install are the way back.

During dual boot (top level):

```
<Arch root files: usr etc var nix ...>   Arch, untouched
home                                     shared /home (existing)
swap                                     swapfile (existing)
.snapshots                               Arch snapper snapshots (existing)
backup-{home,virtualbox,nextcloud}      phase 0 backup snapshots, deleted in phase 2
nixos                                    NixOS /
nixos/nix                                NixOS /nix (nested)
nixos/var/lib/docker                     NixOS Docker (nested)
home-pre-nixos                           read-only snapshot of home before the install
home-pre-nixos-virtualbox                same for home/alex/VirtualBox VMs
home-pre-nixos-nextcloud                 same for home/alex/Nextcloud2
```

Final:

```
nixos            with nested nixos/nix and nixos/var/lib/docker
home
swap
arch             read-only, deleted in phase 6
arch-snapshots   deleted in phase 6
```

## Ground rules

- Arch is not modified until phase 5, except for disabling hibernation
  (phase 0, step 6).
- No hibernation while both systems exist. If NixOS mounts the filesystem
  while Arch is hibernated (or vice versa), btrfs gets corrupted. Always shut
  down fully before switching OS. The NixOS config keeps hibernation off
  (`hibernation = false` in `system/840G6/configuration.nix`) until phase 4.
- Once NixOS has booted, Home Manager owns the dotfiles in the shared home
  (see phase 2). Arch is a fallback from then on.
- Before every destructive step: list what is about to be removed and check it.

## Phase 0: Backups and preparation (on Arch)

Steps 1-4 and 6 done on 2026-10-07 (1-4 in the order 3, 4, 1, 2, so the
dumps and the inventory are part of the home backup). Step 5 skipped: a live
USB can be made on another laptop if it is ever needed.

Backup disk: WD My Passport 1.5 TB, GPT, plain
btrfs, label `backup-840G6`, mounted with `compress=zstd:1`:

```
840G6/subvolumes/backup-{home,virtualbox,nextcloud,etc}   btrfs receive of the snapshots
840G6/files/{var/lib/docker/volumes,var/lib/bluetooth,var/lib/sbctl,usr/local,root}
840G6/luks-header-840G6.img
```

The read-only source snapshots `backup-home`, `backup-virtualbox` and
`backup-nextcloud` stay at the top level as parents for the incremental
backup in phase 2.

1. Full backup to an external disk (~440 GB):
   - read-only snapshots of `home`, `home/alex/VirtualBox VMs`,
     `home/alex/Nextcloud2` and `etc`, each sent with `btrfs send`.
     Nested subvolumes are not part of their parent's snapshot, so
     `VirtualBox VMs` and `Nextcloud2` must be sent on their own.
     `home/.snapshots` and `etc/.snapshots` (snapper history) are skipped.
   - `/var/lib/{docker/volumes,bluetooth,sbctl}`, `/usr/local`, `/root`,
     copied with rsync from a read-only snapshot of `/` (consistent while
     Docker is running)
   - verify: `rsync -n` over every subvolume (metadata of all files
     identical), `cmp` of 300 random files per subvolume, the full Windows 10
     VM disk and the database dumps, `rsync -n -c` of the copied files, read-only
     `btrfs scrub` (cancelled at ~60%, no errors)
2. LUKS header backup, stored off the machine:
   ```sh
   sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 --header-backup-file luks-header-840G6.img
   ```
3. Logical dumps of important Docker databases into `~/arch-migration/db/`
   (`pg_dumpall` / `mariadb-dump --all-databases`), farmtracker first. All
   other database containers were stopped, so their volume files are
   consistent as they are.
4. Inventory into `~/arch-migration/` (not into this repo):
   ```sh
   sudo btrfs subvolume list -a / > ~/arch-migration/subvolumes.txt
   pacman -Qqe > ~/arch-migration/pacman-explicit.txt
   pacman -Qqm > ~/arch-migration/pacman-foreign.txt
   systemctl list-unit-files --state=enabled > ~/arch-migration/units-system.txt
   systemctl --user list-unit-files --state=enabled > ~/arch-migration/units-user.txt
   sudo cp -a /etc ~/arch-migration/etc
   sudo cp -a /boot ~/arch-migration/esp-backup
   ```
5. Create a NixOS live USB and verify it boots and can unlock the LUKS volume.
6. Disable hibernation on Arch for the dual-boot period:
   ```sh
   sudo systemctl mask hibernate.target suspend-then-hibernate.target hybrid-sleep.target
   ```
   Arch's `logind.conf` sends the lid to `suspend-then-hibernate`, which does
   nothing once that target is masked. The drop-in
   `/etc/systemd/logind.conf.d/no-hibernate.conf` switches the lid to plain
   `suspend` (applied with `sudo systemctl kill -s HUP systemd-logind`).

## Phase 1: `840G6` config in this repo (done)

- Host: `modules/hosts/840G6.nix`, `system/840G6/configuration.nix`,
  `system/840G6/hardware-configuration.nix`
- Shared profile `modules/profiles/workstation.nix` (also used by
  PCNX-LeiAle1), plus the 840G6-only features listed in the host file
- Decisions and what was ported or dropped: [840G6-inventory.md](840G6-inventory.md)

Validate before touching the disk:

```sh
nix build ~/.dotfiles#nixosConfigurations.840G6.config.system.build.toplevel -o ~/arch-migration/nixos-system
```

Flakes only see tracked files; run `jj status` after adding files.

## Phase 2: Side-by-side install (from running Arch)

Installing from Arch (which already has Nix) keeps flake inputs like
`git+file:///home/alex/projects/smart-bulb` reachable. Arch stays bootable
as the fallback; a live USB can be made on another laptop if both fail.

```sh
# rollback point for /home; nested subvolumes need their own snapshots
sudo btrfs subvolume snapshot -r /home /home-pre-nixos
sudo btrfs subvolume snapshot -r "/home/alex/VirtualBox VMs" /home-pre-nixos-virtualbox
sudo btrfs subvolume snapshot -r /home/alex/Nextcloud2 /home-pre-nixos-nextcloud

# incremental backup on top of phase 0 (only sends the changes)
sudo mount -o compress=zstd:1,noatime LABEL=backup-840G6 /mnt/backup
sudo btrfs send -p /backup-home /home-pre-nixos | sudo btrfs receive /mnt/backup/840G6/subvolumes
sudo btrfs send -p /backup-virtualbox /home-pre-nixos-virtualbox | sudo btrfs receive /mnt/backup/840G6/subvolumes
sudo btrfs send -p /backup-nextcloud /home-pre-nixos-nextcloud | sudo btrfs receive /mnt/backup/840G6/subvolumes
sudo btrfs subvolume snapshot -r /etc /etc-pre-nixos
sudo btrfs send /etc-pre-nixos | sudo btrfs receive /mnt/backup/840G6/subvolumes
sudo btrfs subvolume delete /etc-pre-nixos
sudo btrfs subvolume snapshot -r / /root-pre-nixos
(cd /root-pre-nixos && sudo rsync -aHAX --numeric-ids --delete --relative \
  var/lib/docker/volumes var/lib/bluetooth var/lib/sbctl usr/local root /mnt/backup/840G6/files/)
sudo btrfs subvolume delete /root-pre-nixos
sudo umount /mnt/backup
sudo btrfs subvolume delete /backup-home /backup-virtualbox /backup-nextcloud

# NixOS subvolumes; Arch's / is the top level, so they land there
sudo btrfs subvolume create /nixos
sudo mkdir -p /nixos/var/lib
sudo btrfs subvolume create /nixos/nix
sudo btrfs subvolume create /nixos/var/lib/docker

# mount the target
sudo mkdir -p /mnt/nixos
sudo mount -o subvol=nixos /dev/mapper/cryptroot /mnt/nixos
sudo mkdir -p /mnt/nixos/{home,swap,boot}
sudo mount -o subvol=home /dev/mapper/cryptroot /mnt/nixos/home
sudo mount -o subvol=swap /dev/mapper/cryptroot /mnt/nixos/swap
sudo mount --bind /boot /mnt/nixos/boot

# build and install
nix build ~/.dotfiles#nixosConfigurations.840G6.config.system.build.toplevel -o ~/arch-migration/nixos-system
nix shell github:NixOS/nixpkgs/nixos-26.05#nixos-install-tools
sudo env PATH="$PATH" nixos-install --root /mnt/nixos --system ~/arch-migration/nixos-system
sudo nixos-enter --root /mnt/nixos -c 'passwd alex'

# state to carry over
sudo mkdir -p /mnt/nixos/etc/NetworkManager/system-connections /mnt/nixos/etc/ssh
sudo cp -a /etc/NetworkManager/system-connections/. /mnt/nixos/etc/NetworkManager/system-connections/
sudo cp -a /etc/ssh/ssh_host_ed25519_key{,.pub} /etc/ssh/ssh_host_rsa_key{,.pub} /mnt/nixos/etc/ssh/
sudo mkdir -p /mnt/nixos/var/lib
sudo cp -a /var/lib/bluetooth /mnt/nixos/var/lib/

# nixos-install rewrites loader.conf; keep Arch as default for now
sudo bootctl set-default arch.conf
bootctl list
```

Notes:

- Arch's files and existing subvolumes are untouched; Arch just sees new
  directories `nixos` and `home-pre-nixos*` at `/`.
- Both systems now update the shared systemd-boot binary. That is fine for
  the dual-boot period.
- The `home-pre-nixos*` snapshots pin the state of home at install time;
  space freed afterwards is only released once they are deleted (phase 5).
- On the first NixOS boot, Home Manager links its files into the shared home.
  Stow links and files in the way (`.zshrc`, `~/.config/{hypr,alacritty,
  ghostty,nvim,opencode}`, `~/.ssh/config`, the hand-written `mpris-proxy`
  and `hyprmoncfgd` user units, ...) are renamed to `*.pre-hm`, nothing is
  overwritten. Check with `journalctl -u home-manager-alex` and
  `find ~ -maxdepth 4 -name '*.pre-hm'`.
- Home Manager's links point into the Nix store. Arch keeps working with
  them as long as the same system closure is in Arch's own `/nix/store`: the
  `~/arch-migration/nixos-system` link built above is a GC root for exactly
  that. After changing the config on NixOS, rebuild it on Arch the same way
  if Arch should keep matching dotfiles.

Rolling back `/home` (from a live USB made on another laptop, if NixOS damages it badly; for
single files use the `*.pre-hm` copies or the snapshots directly):

```sh
mount -o subvolid=5 /dev/mapper/cryptroot /mnt
mv /mnt/home /mnt/home-nixos-broken
btrfs subvolume snapshot /mnt/home-pre-nixos /mnt/home
# nested subvolumes: take the current ones back (or snapshot the -pre-nixos ones)
for sv in .snapshots "alex/VirtualBox VMs" alex/Nextcloud2; do
  rmdir "/mnt/home/$sv"
  mv "/mnt/home-nixos-broken/$sv" "/mnt/home/$sv"
done
```

Anything written to home after the snapshot is then only in
`home-nixos-broken` and can be copied back from there.

## Phase 3: Test NixOS (Arch stays default)

Boot into NixOS once with `sudo bootctl set-oneshot nixos-generation-1.conf`
or pick it in the boot menu.

Checklist:

- [ ] LUKS unlock with German layout
- [ ] Wi-Fi (saved connections), Bluetooth (paired devices, headset buttons
      via mpris-proxy), audio (speakers are known broken, see
      [todo.md](todo.md); mic, headset)
- [ ] Suspend/resume (BE200 `btintel_pcie` unload/reload), lid, brightness
- [ ] Dock, Thunderbolt, external monitors, hyprmoncfg profile switching
- [ ] Hyprland + DMS, portals, screen sharing, clipboard
- [ ] Docker, VirtualBox (Windows 10 VM in `~/VirtualBox VMs`)
- [ ] Printing (HP LaserJet)
- [ ] VPN (work OpenVPN split tunnel, WireGuard)
- [ ] rbw / SSH agent, git credentials, gnome-keyring
- [ ] adb, fnm (`node` per project)
- [ ] Battery life with power-profiles-daemon
- [ ] Steam

Fix issues with `sudo nixos-rebuild switch --flake ~/.dotfiles#840G6`
(works from NixOS; on Arch edit and commit, then rebuild after booting NixOS).

## Phase 4: Swap to NixOS as the primary system

1. On Arch, one last time: stop Docker, take fresh database dumps, shut down
   (not hibernate).
2. On NixOS, migrate Docker volumes (instant reflink copy, Arch's data stays
   in place):
   ```sh
   sudo mkdir -p /mnt/top
   sudo mount -o subvolid=5 /dev/mapper/cryptroot /mnt/top
   sudo systemctl stop docker.socket docker.service
   sudo cp -a --reflink=always /mnt/top/var/lib/docker/volumes/. /var/lib/docker/volumes/
   sudo systemctl start docker
   docker volume ls
   ```
   Then `docker compose up` in each project and verify the data. Images are
   pulled again; anonymous volumes of old containers are preserved but orphaned.
3. Enable hibernation: set `hibernation = true` in
   `system/840G6/configuration.nix`. Re-check the offset first with
   `sudo btrfs inspect-internal map-swapfile -r /swap/swapfile` (24751 on
   Arch). With a resume device set, the lid switches to
   suspend-then-hibernate automatically. Hibernation stays masked on Arch.
4. Make NixOS the default: `sudo bootctl set-default ""`.
5. Daily-drive NixOS for 2-4 weeks. Boot Arch only in an emergency: older Arch
   app versions (Zen, Helium, Thunderbird, Signal) can damage profiles already
   migrated by newer versions.

## Phase 5: Remove dual boot, keep Arch as `arch` (from NixOS)

1. Mount the top level and list what is there:
   ```sh
   sudo mount -o subvolid=5 /dev/mapper/cryptroot /mnt/top
   ls -la /mnt/top
   sudo btrfs subvolume list -a /mnt/top
   ```
2. Snapshot the Arch root and remove placeholders of unrelated subvolumes:
   ```sh
   sudo btrfs subvolume snapshot /mnt/top /mnt/top/arch
   sudo rmdir /mnt/top/arch/{nixos,home,swap,home-pre-nixos,home-pre-nixos-virtualbox,home-pre-nixos-nextcloud,.snapshots}
   ```
3. Snapshots do not include nested subvolumes; add Arch's own:
   ```sh
   for sv in etc srv var/log var/lib/machines var/lib/portables; do
     sudo rmdir /mnt/top/arch/$sv
     sudo btrfs subvolume snapshot /mnt/top/$sv /mnt/top/arch/$sv
   done
   ```
   Skipped on purpose (left as empty directories in `arch`): `tmp`, `var/tmp`,
   `var/abs`, `var/cache/pacman/pkg` (23 GB of downloadable packages),
   `etc/.snapshots` (snapper history of `/etc`) and Docker image subvolumes
   (images can be pulled again; volumes are regular directories and already
   included).
4. Keep a copy of Arch's ESP files:
   ```sh
   sudo mkdir /mnt/top/arch/esp-backup
   sudo cp -a /boot/loader/entries/arch*.conf /boot/vmlinuz-linux* /boot/initramfs-* \
     /boot/intel-ucode.img /mnt/top/arch/esp-backup/
   ```
5. Verify, then make it read-only:
   ```sh
   sudo ls /mnt/top/arch/etc/NetworkManager/system-connections \
     /mnt/top/arch/var/lib/docker/volumes /mnt/top/arch/usr/local/bin
   sudo btrfs property set -ts /mnt/top/arch ro true
   ```
6. Keep Arch's snapper snapshots alongside:
   ```sh
   sudo mv /mnt/top/.snapshots /mnt/top/arch-snapshots
   ```
7. Remove Arch from the top level. Never touch `nixos`, `home`, `swap`,
   `arch`, `arch-snapshots`, `home-pre-nixos*`.
   ```sh
   # nested subvolumes first, deepest first
   sudo btrfs subvolume list -o /mnt/top/var/lib/docker/btrfs/subvolumes   # review
   sudo btrfs subvolume delete /mnt/top/var/lib/docker/btrfs/subvolumes/*
   sudo btrfs subvolume delete /mnt/top/etc/.snapshots/*/snapshot
   sudo btrfs subvolume delete /mnt/top/etc/.snapshots
   sudo btrfs subvolume delete /mnt/top/{etc,srv,tmp,var/tmp,var/log,var/abs,var/cache/pacman/pkg,var/lib/machines,var/lib/portables}
   sudo btrfs subvolume list -a /mnt/top | grep -vE ' path (<FS_TREE>/)?(nixos|home|swap|arch|arch-snapshots|home-pre-nixos[a-z-]*)(/|$)'   # should be empty

   # then the Arch root directories, explicit list only
   ls -la /mnt/top
   sudo rm -rf /mnt/top/{usr,var,opt,root,media,mnt,nix,store,.store,.oldroot,.bootbackup,tmp,dev,proc,sys,run,boot,bin,lib,lib64,sbin,snap}
   ls -la /mnt/top   # only nixos, home, swap, arch, arch-snapshots, home-pre-nixos* left
   ```
   Space is not freed yet; `arch` still references the data.
8. Clean the ESP and let NixOS own it:
   ```sh
   sudo rm /boot/loader/entries/arch*.conf /boot/vmlinuz-linux* /boot/initramfs-* /boot/intel-ucode.img
   sudo nixos-rebuild boot --flake ~/.dotfiles#840G6
   bootctl list
   ```
9. Delete the pre-install home snapshots once NixOS has been in daily use
   without trouble:
   ```sh
   sudo btrfs subvolume delete /mnt/top/home-pre-nixos{,-virtualbox,-nextcloud}
   ```
10. Hibernation can now be used freely on NixOS.
11. Repo cleanup: remove `arch`, `install`, `clean-env` and stow-only
    directories no longer referenced by any module; update `README.md`.

Optional follow-ups:

- Secure Boot via lanzaboote, reusing the sbctl keys
- TPM2 unlock with `systemd-cryptenroll`

Emergency access to Arch: `arch` can be booted again by creating a writable
snapshot of it, restoring the files from `esp-backup` to the ESP and adding a
boot entry with `rootflags=subvol=<snapshot>`.

## Phase 6: Delete Arch (after 1-3 months)

Prerequisites:

- at least one full backup taken from NixOS and test-restored
- went through the "data outside `/home`" list above and confirmed nothing
  else is needed from `arch`

```sh
sudo mount -o subvolid=5 /dev/mapper/cryptroot /mnt/top
sudo btrfs property set -ts /mnt/top/arch ro false   # nested subvolumes can't be removed from a read-only parent
sudo btrfs subvolume delete /mnt/top/arch/{etc,srv,var/log,var/lib/machines,var/lib/portables}
sudo btrfs subvolume delete /mnt/top/arch
sudo btrfs subvolume list -o /mnt/top/arch-snapshots   # review
sudo btrfs subvolume delete /mnt/top/arch-snapshots/*/snapshot
sudo btrfs subvolume delete /mnt/top/arch-snapshots
```

Leftover Arch-specific files in `/home` (e.g. `~/.nix-profile` pointing at the
old Arch store) are harmless and can be cleaned up at leisure.

## Open items

Deferred items: [todo.md](todo.md).

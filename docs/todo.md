# Todo

Open tasks.

## configs/ migration

Move every machine to the `configs/<app>/` layout with
[configs-migration.md](configs-migration.md):

- [x] LTNX-LeiAle1 (NixOS)
- [ ] PCNX-LeiAle1 (NixOS); before the rebuild also check that `id -u alex`
  is 1000 and `getent group 1000` is empty or `alex` (the account gets
  uid/gid 1000 and the primary group `alex`)
- [x] TR (Arch)
- [ ] X1C6 (Arch)

Once all four are done, delete `docs/configs-migration.md`, its links in
README.md and AGENTS.md, and this section.

## TR to NixOS

Reinstall TR as NixOS with [tr-nixos-migration.md](tr-nixos-migration.md):

- [x] Phase 0: free space, repo to `configs/`, nix on Arch
- [x] Phase 1: host `TR` and its features in the repo
- [x] Phase 2: install from Arch next to it
- [ ] Phase 3: first boot, port the "wip(TR)" commit
- [ ] Phase 4: remove Arch

## TPM on TR

The firmware (MSI X399 SLI PLUS) announces a TPM2 (AMD fTPM) in ACPI, but
`tpm_crb` can't claim it ("ACPI region does not cover the entire
command/response buffer", `-EBUSY`), so `/dev/tpmrm0` never appears and
`tpm2.target` waits 90 s on boot. Workaround: `systemd.tpm2_wait=0` in
`modules/hosts/TR/configuration.nix` (on Arch: `dev-tpmrm0.device` and
`tpm2.target` masked). Fix: BIOS update, or switch the fTPM off in the BIOS
if nothing needs it; then drop the parameter.

## Hibernate mode (LTNX-LeiAle1)

With BIOS 01.06.02:

- Every resume from hibernate logs `ACPI BIOS Error (bug): The DSDT has been
  corrupted or replaced` and `\_WAK` aborts; afterwards the lid, AC and dock
  state are unreadable (logind thinks it's docked with the lid closed and
  ignores the lid). Workaround: `acpi=copy_dsdt`.
- Suspend-then-hibernate can hang entering S4 after the timer wake (screen
  off, keyboard backlight on, power button unresponsive); seen once without
  `acpi=copy_dsdt`. The default `platform` mode is on trial. If it hangs
  again, set `systemd.sleep.settings.Sleep.HibernateMode = "shutdown"`.
- Lid wake from hibernate doesn't work in either mode: there is no ACPI wake
  device for the lid, so only the BIOS option "Power On When Lid is Opened"
  (if available) can do it.

`acpi=copy_dsdt` is in `modules/hosts/LTNX-LeiAle1/configuration.nix`. After the next BIOS
update, drop it and retest (`HibernateDelaySec=2min` in a temporary
`/etc/systemd/sleep.conf.d/test.conf`; check `journalctl -k -b | grep DSDT`).

## Plaintext secrets

Plaintext copies of an `OPENROUTER_API_KEY` (`/etc/environment`) and the
work CIFS password (an autofs map, a commented `/etc/fstab` line,
`/etc/samba/credentials/share`) are in `~/arch-migration/etc` and on both
backup disks (see below). Rotate both; if the OpenRouter key is still needed,
keep it in rbw.

## Migration leftovers

- `~/arch-migration`: database dumps, copies of `/etc` and the ESP, and the
  `nixos-system` link, a GC root that keeps the first NixOS system in the
  store. Delete once nothing in it is needed.
- Backups of replaced files: `*.pre-hm` from Home Manager
  (`find ~ -maxdepth 4 -name '*.pre-hm'`) and `*.pre-nixos`.
- Files in `/home` that only work on Arch: `~/.scripts` (5 of 7 use
  `#!/bin/bash`), pip `--user` tools in `~/.local/bin` (shebangs point at
  Arch's Python), desktop files in `~/.local/share/applications` pointing at
  `/opt` or `/usr/bin`.

## Backup disks

The archive NVMe (`archive-840G6`: Arch root and the `home-pre-nixos*`
snapshots) and the My Passport (`backup-840G6`: pre-migration backup) can be
wiped once nothing more is needed from Arch. They also hold the sbctl key
backups listed in [secure-boot.md](secure-boot.md) and the plaintext secrets
above; keep a key copy elsewhere first.

## Repo cleanup

The stow setup (`arch`, `install`, the stow-only package folders) stays while
two other machines still run Arch. Remove it once they are migrated.

## TLP vs power-profiles-daemon (LTNX-LeiAle1)

LTNX-LeiAle1 uses power-profiles-daemon, which DMS needs for its power profile
switcher. Decide between

- power-profiles-daemon only (DMS integration, less tuning), or
- TLP with [`attic/tlp/01-elitebook.conf`](attic/tlp/01-elitebook.conf)
  (`services.tlp.settings`; DMS power switcher won't work, unless TLP's
  power-profiles compatible daemon `tlp-pd` is used)

## Battery runtime (LTNX-LeiAle1)

Check a full day on battery with power-profiles-daemon; ties in with the TLP
decision above.

## sleep-on-unplug (LTNX-LeiAle1)

Suspend-then-hibernate when AC is unplugged while docked with the lid closed
(logind ignores the lid when docked and never re-evaluates on unplug).
Not ported. Files: [`attic/sleep-on-unplug/`](attic/sleep-on-unplug/)
(script, systemd unit with `SLEEP_ON_UNPLUG_DRYRUN=1`, udev rule). On NixOS this would be a `systemd.services` unit plus
`services.udev.extraRules`; the script optionally uses `evtest`.

## Speakers (LTNX-LeiAle1)

Both Cirrus CS35L54 amps bind, load their firmware and apply calibration
(kernel 6.18). Check whether the internal speakers actually play.

## Sensor hub (LTNX-LeiAle1)

The ISH firmware doesn't load (`intel_ish_ipc: ISH loader: load firmware:
intel/ish/ish_lnlm.bin`, then `cmd 2 failed 10`), so the hub's sensors
(ambient light, accelerometer, ...) are unavailable. Check whether anything
needs them.

## TPM enrollment docs

`modules/features/measured-boot.nix` points to [secure-boot.md](secure-boot.md)
for the manual LUKS enrollment (TPM2 + PIN), but that step isn't documented
there yet.

## lanzaboote fwupd integration

lanzaboote's `fwupd-efi` unit sets `FWUPD_EFIAPPDIR`, which fwupd 2.x
ignores; the `secure-boot` feature works around it with a bind mount (see
[secure-boot.md](secure-boot.md)). Report upstream and drop the workaround
once lanzaboote handles it.

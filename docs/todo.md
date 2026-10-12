# Todo

Open tasks.

## configs/ migration

Move every machine to the `configs/<app>/` layout with
[configs-migration.md](configs-migration.md):

- [x] LTNX-LeiAle1 (NixOS)
- [ ] PCNX-LeiAle1 (NixOS); before the rebuild also check that `id -u alex`
  is 1000 and `getent group 1000` is empty or `alex` (the account gets
  uid/gid 1000 and the primary group `alex`)
- [x] TR (NixOS)
- [ ] X1C6 (Arch)

Once all four are done, delete `docs/configs-migration.md`, its links in
README.md and AGENTS.md, and this section.

## Pangolin login

`pangolin login` on each development host ([pangolin.md](pangolin.md)):

- [ ] LTNX-LeiAle1
- [ ] PCNX-LeiAle1
- [ ] TR

## TR first-boot checks

TR was reinstalled from Arch as NixOS with `/home` kept. Still to check at
the machine:

- [ ] rbw: both profiles (`rbw config set pinentry rbw-pinentry-keyring`),
  then `ssh-add -l`
- [ ] Steam games start (missing Proton-GE versions: protonup-qt)
- [ ] Hyprland session via GDM with both monitors:
  `modules/hosts/TR/monitors.lua` matches `hyprctl monitors`
- [ ] Xbox controller pairs (xpadneo)
- [ ] Sunshine: `output_name = 1` in `~/.config/sunshine/sunshine.conf` is
  the second monitor; adjust it for one monitor
- [ ] Zen: delete the empty profile `default` in `about:profiles`
- [ ] Port what's worth keeping from the commit "wip(TR): uncommitted
  changes from TR" (nvim treesitter rewrite, DMS settings, opencode) into
  `configs/`, then abandon it

## Hibernate mode (LTNX-LeiAle1)

With BIOS 01.06.02, a resume from hibernate can leave the ACPI tables
unusable. Linux executes the firmware's tables in place, in ACPI reclaim
memory that isn't part of the hibernation image. The resume is a cold boot,
and the firmware doesn't always lay the tables out the same way: seen once,
every table from `HP_XHC_P` (0x69F95000 at boot) downwards had moved down
by one page, with a `BERT` (boot error record) present that the original
boot didn't have. The kernel then runs garbage for those tables:

- `\_WAK` aborts (`Could not resolve symbol [\_SB.ED21.QE]`); the embedded
  controller's helpers call `\_SB.ED21`, so battery (`BAT0._STA`), AC
  (`AC._PSR`) and lid/dock state are unreadable and ACPI errors repeat
  every few seconds;
- `DptfTabl`: the thermal zones TCPU, SEN1, SEN2 and SEN6 are disabled
  ("Unable to get temperature, disabling!");
- `NHLT`: the SOF audio driver oopses in `intel_nhlt_get_endpoint_blob` the
  first time PipeWire opens the internal card. The pipewire process is left
  a zombie and audio dies again whenever the internal speakers or mic are
  used.

Nothing recovers this at runtime; only a reboot does. `acpi=copy_dsdt`
covers the DSDT alone (the kernel can copy no other table), which is why
the DSDT-only failures ("The DSDT has been corrupted or replaced") are gone
and these remain. Compare the table headers with the boot log to confirm:
`journalctl -k -b -g 'ACPI: (SSDT|NHLT) 0x'` against
`sudo head -c 4 /sys/firmware/acpi/tables/SSDT<n>` (should be `SSDT`).

Suspend-then-hibernate also hung entering S4 after the timer wake once
(screen off, keyboard backlight on, power button unresponsive), in the
`platform` mode. `HibernateMode = "shutdown"` is on trial: after a few
hibernations, check each resume with `journalctl -k -b -p 3 -g ACPI` and
`upower -d`. The firmware rebuilds the tables in both modes, so if the
breakage recurs, the options are `hibernation = false` until a BIOS update,
or `acpi_sleep=s4_hwsig` (a fresh boot instead of the resume when the
firmware reports a changed FACS hardware signature, if HP changes it).

Lid wake from hibernate doesn't work in either mode: there is no ACPI wake
device for the lid, so only the BIOS option "Power On When Lid is Opened"
(if available) can do it.

`acpi=copy_dsdt` and `HibernateMode` are in
`modules/hosts/LTNX-LeiAle1/configuration.nix`. After the next BIOS update,
drop both and retest (`HibernateDelaySec=2min` in a temporary
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

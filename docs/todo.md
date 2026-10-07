# Todo

Deferred items from the 840G6 Arch -> NixOS migration
(see [840G6-inventory.md](840G6-inventory.md)).

## Before installing NixOS on 840G6

- **Backup disk**: needs room for ~430 GB (see phase 0 of the migration plan).

## TLP vs power-profiles-daemon (840G6)

On Arch `tlp.service` is enabled but never runs: it conflicts with
power-profiles-daemon, which DMS activates over D-Bus for its power profile
switcher. The tuned TLP settings therefore have no effect today.

NixOS starts out with power-profiles-daemon (same effective state as Arch).
Later: decide between

- power-profiles-daemon only (DMS integration, less tuning), or
- TLP with [`attic/tlp/01-elitebook.conf`](attic/tlp/01-elitebook.conf)
  (`services.tlp.settings`; DMS power switcher won't work, unless TLP's
  power-profiles compatible daemon `tlp-pd` is used)

## sleep-on-unplug (840G6)

Suspend-then-hibernate when AC is unplugged while docked with the lid closed
(logind ignores the lid when docked and never re-evaluates on unplug).
Was still in dry-run mode on Arch. Not ported. Original files:
[`attic/sleep-on-unplug/`](attic/sleep-on-unplug/) (script, systemd unit,
udev rule). On NixOS this would be a `systemd.services` unit plus
`services.udev.extraRules`; the script optionally uses `evtest`.

## Speakers (840G6)

The internal speakers have a driver issue (Cirrus CS35L56 amps; at boot the
kernel logs `spi_master spi1: error -EINVAL: failed to add SPI device
CSC3554:00 from ACPI`, an HP firmware/ACPI bug). Not addressed during the
migration.

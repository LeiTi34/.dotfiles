# Secure Boot

Feature `secure-boot` (`modules/features/secure-boot.nix`): lanzaboote
replaces systemd-boot and signs the boot files with sbctl keys in
`/var/lib/sbctl`. Used by 840G6.

## Keys

The keys are not in this repo. 840G6's sbctl keys (owner GUID
`140964ed-43c1-4d57-8fbd-7a0de0fc302b`, valid until 2031-03-31) are enrolled
in the firmware together with Microsoft's certificates (needed for option
ROMs, e.g. Thunderbolt/dock). Copies:

- archive NVMe (`archive-840G6`): `840G6/arch/var/lib/sbctl`
- My Passport (`backup-840G6`): `840G6/files/var/lib/sbctl`

Restore (root only, keys `600`):

```sh
sudo cp -a <backup>/var/lib/sbctl /var/lib/sbctl
sudo chown -R root:root /var/lib/sbctl && sudo chmod 700 /var/lib/sbctl
sudo sbctl status   # owner GUID, setup mode disabled, vendor keys: microsoft
```

New machine or lost keys: `sudo sbctl create-keys`, clear the Secure Boot
keys in the firmware (setup mode), then `sudo sbctl enroll-keys --microsoft`.

## Enabling

1. Restore or create the keys (above); `/var/lib/sbctl/files.json` stays
   `{}` (lanzaboote signs its own files).
2. Back up the ESP, switch to the config with the `secure-boot` feature.
3. `sudo sbctl verify`: everything signed except
   `EFI/nixos/kernel-*.efi` (lanzaboote checks kernel and initrd by hash).
4. Remove systemd-boot leftovers from the ESP:
   `loader/entries/nixos-generation-*.conf`, unsigned
   `EFI/systemd/systemd-boot-fallbackx64.efi` and `EFI/systemd/fwupdx64.efi`.
5. Reboot with Secure Boot still off; `bootctl status` shows the lanzaboote
   stub.
6. HP BIOS (F10) → Advanced → Secure Boot Configuration: enable Secure Boot.
   Don't clear or reset keys. Set a BIOS admin password, otherwise Secure
   Boot can simply be turned off again.
7. `bootctl status` → `Secure Boot: enabled (user)`; check suspend,
   hibernate, dock, VirtualBox (unsigned out-of-tree modules load: the NixOS
   kernel doesn't enforce module signatures). `fwupdmgr security` reports
   PK/db valid and Secure Boot enabled.

If it doesn't boot: turn Secure Boot off in the BIOS.

## fwupd

With Secure Boot on, fwupd only uses `fwupdx64.efi.signed` from its EFI app
directory, which is compiled into fwupd as the read-only `fwupd-efi` store
path. lanzaboote's own `fwupd-efi` unit points fwupd at `/run/fwupd-efi` via
`FWUPD_EFIAPPDIR`, but fwupd 2.x ignores that variable. So the
feature masks that unit and instead:

- `fwupd-efi-sign.service` signs `fwupdx64.efi` with the db key into
  `/var/lib/fwupd-efi/` before fwupd starts (re-runs when fwupd-efi changes)
- `fwupd.service` gets `BindReadOnlyPaths=/var/lib/fwupd-efi:<fwupd-efi>/libexec/fwupd/efi`
- `DisableShimForSecureBoot = true` (set by lanzaboote)

Check: `sudo nsenter -t $(pidof fwupd) -m ls <fwupd-efi>/libexec/fwupd/efi`
lists `fwupdx64.efi.signed`. fwupd copies it to the ESP when it schedules a
capsule update. UEFI `dbx` updates from LVFS are signed by Microsoft's KEK,
which stays enrolled.

BIOS updates with `fwupdmgr update` work with Secure Boot on (the firmware
has no capsule-on-disk, so fwupd uses its EFI app plus `BootNext`). An
attempt can come back with `boot entry missing: no 'Linux Firmware Updater'
entry found` and no flash, although the OS side (entry, `BootNext`, signed
app, staged capsule) is fine; retrying works. For details, temporarily set
`services.fwupd.uefiCapsuleSettings.EnableEfiDebugging = true`; the EFI app's
log ends up in the `FWUPDATE_DEBUG_LOG` EFI variable (UTF-16).

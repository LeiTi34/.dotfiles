# Power and sleep (laptops)

The `laptop` feature (`modules/features/laptop.nix`) sets the sleep policy;
hosts with a resume device (`boot.resumeDevice`) get hibernation, the others
fall back to suspend and power-off.

| Event | Action |
|---|---|
| Lid closed, undocked (battery or charger) | suspend-then-hibernate |
| Lid closed, docked or with an external display | nothing (`HandleLidSwitchDocked=ignore`) |
| Undocked while the lid is closed | suspend-then-hibernate: logind rechecks a closed lid after every event, once the dock and displays are gone the undocked action applies (after `HoldoffTimeoutSec`, 30 s) |
| Charger unplugged, lid closed, external display still connected | nothing (counts as docked) |
| Battery at 2% while awake | hibernate (UPower `PercentageAction`, `CriticalPowerAction=Hibernate`) |
| Suspended for `HibernateDelaySec` (60 min) | hibernate |

UPower's default `CriticalPowerAction=HybridSleep` writes the image but
stays suspended, which drains the rest of the battery; hence `Hibernate`.

## Low battery during suspend (LTNX-LeiAle1)

systemd-sleep's suspend-then-hibernate also hibernates on low battery: when
the battery has an ACPI alarm (`/sys/class/power_supply/BAT0/alarm` > 0,
`_BTP`), it relies on the firmware waking the machine at the alarm level
and tells that wake from a user wake by the SMBIOS type 1 wake-up type
("APM Timer"). The HP firmware always reports "Power Switch"
(`sudo od -An -tu1 -j24 -N1 /sys/firmware/dmi/entries/1-0/raw` gives 6), so
a battery-alarm wake would count as a user wake. Only the 60 min timer
hibernates; suspend drains about 1–2%/h, so it fires long before the
battery is empty.

Writing `0` to `BAT0/alarm` (udev rule) would make systemd fall back to its
own estimation wakeups (hibernate at ≤5% or after the delay); not done,
the timer is enough.

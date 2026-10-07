# 840G6 inventory (Arch, before NixOS migration)

Snapshot of everything on the Arch install that is not stock, as input for
the NixOS config (see [nixos-migration-840G6.md](nixos-migration-840G6.md)).
Fill in the **Decision** column (`port` / `drop` / `later`); anything left
empty gets the suggested action.

Suggestions:

- **port**: needed, translate to NixOS config
- **data**: state to copy over, not config
- **decide**: works today but may no longer be needed
- **drop**: dead, leftover from an older machine/setup, or Arch-only

How it was gathered: modified package config files (`pacman -Qii`), files not
owned by any package in `/etc`, `/usr`, `/opt`, `/var/lib`, enabled units,
`pacman -Qkk` (no modified files under `/usr`), running services, hardware, and
the root-only paths (NetworkManager, snapper, cups, `/root`, ...).

Empty or stock, nothing to port: `/etc/crypttab`, `/etc/cryptsetup-keys.d`,
`/etc/credstore*`, `/etc/sudoers.d`, `/etc/polkit-1/rules.d`, `/etc/wireguard`,
`/etc/apparmor.d/local`, `/etc/cups/ssl`, `/etc/docker/daemon.json` (absent).

Plaintext secrets found (values intentionally not reproduced here):
`OPENROUTER_API_KEY` in `/etc/environment`, CIFS password in
`/etc/autofs/auto.*`, a commented line in `/etc/fstab` and
`/etc/samba/credentials/share`. Rotate, and move to rbw/sops if still needed.

## Decisions (2026-10-07)

General rule: prefer the existing feature modules used by PCNX-LeiAle1, even
if they differ slightly from the Arch setup; shared config goes into
`modules/features`, only machine-specific bits into the host. Bigger
differences get reported first.

| Topic | Decision |
|---|---|
| Firewall | enable `networking.firewall`, open only TCP 22 for now |
| VirtualBox | keep, latest from the stable channel (no pinning needed) |
| Caddy local CA | drop (trusted root and `/root/.local/share/caddy`) |
| Leftovers (§1 "drop" rows, `/opt`, `/var/lib`, unowned files) | drop |
| autofs, SMB mount dispatcher scripts | drop |
| `delete-tun0-default-route.sh` | drop; `ipv4.never-default` and `ipv6.never-default` set on the work VPN connection (done on Arch, carried over with the connection files) |
| Xerox driver | drop |
| Speakers | not fixed in migration, see [todo.md](todo.md) |
| tlp vs power-profiles-daemon | keep power-profiles-daemon for now, see [todo.md](todo.md) |
| sleep-on-unplug | not ported, see [todo.md](todo.md) |
| `~/.scripts` | kept as-is in `/home` (may break, fine) |
| `~/.local/bin` pip tools | kept as-is in `/home`, not made to work |
| mpris-proxy | Home Manager `services.mpris-proxy` (the hand-written unit gets renamed to `*.pre-hm`) |
| Android | drop SDK and Flutter; `adb` must work |
| Node | fnm as shared module, enabled on both 840G6 and PCNX-LeiAle1 |
| zsh | same config as PCNX-LeiAle1 (`modules/features/shell.nix`), no vi mode, no grml/bun/thefuck |
| Login | same as PCNX-LeiAle1 (tty login, start Hyprland manually) |
| Locale | same as PCNX-LeiAle1: `en_US.UTF-8`, console keymap `de` |
| Time sync | systemd-timesyncd (NixOS default) like PCNX-LeiAle1; chrony dropped |
| Kernel | default kernel of the stable channel (6.18 LTS) |
| `/home` | shared from the first NixOS boot, read-only `home-pre-nixos*` snapshots as rollback |
| Docker storage driver | `btrfs`, like PCNX-LeiAle1 |
| AppArmor, btrbk, krb5, Bluetooth `main.conf` tweaks, fprintd, `mtk_t7xx` blacklist, kexec-tools, acpi_call, powertop | drop |
| snapper | `home` timeline only (same retention as Arch); snapper-gui, snap-sync, snp dropped |
| headsetcontrol | keep (nixpkgs package incl. udev rules) |
| Printers | HP LaserJet declared in config (generic PCL driver); Xerox only via driverless if ever needed |
| `pcspkr` blacklist | keep |
| Packages (§3) | 840G6-only feature modules: `thunderbird`, `spellcheck` (hunspell/hyphen de_AT, en_GB, en_US for LibreOffice), `gimp`, `feh`, `rustdesk`, `postman`, `gh`, `glab`, `azure-cli`, `azd` (1.35.0 release binary, not in nixpkgs), `btdu`, `zip`, `rsync`, `net-tools`, `traceroute`, `whois`, `xdg-user-dirs`, `fonts-extra` (core, icon and extra sans fonts; Phosphor packaged from npm; croscore covered by Liberation 2.x), `vpn` (NetworkManager OpenVPN plugin). Theming same as PCNX-LeiAle1. Everything else in §3 not marked ✓ is dropped |

## 0. Disk layout and sizes

btrfs subvolumes (Docker's 2489 image subvolumes and the snapper snapshots
omitted):

| Subvolume | Mounted at (Arch) | Notes |
|---|---|---|
| top level (id 5) | `/` | Arch root files live directly here |
| `home` | `/home` | 409 GB |
| `home/.snapshots` | | snapper `home` |
| `home/alex/VirtualBox VMs` | | nested in `home`, 74 GB |
| `home/alex/Nextcloud2` | | nested in `home`, 40 GB |
| `swap` | `/swap` | 32 GiB swapfile |
| `etc` | `/etc` | |
| `etc/.snapshots` | | snapper `etc` |
| `.snapshots` | | snapper `root` |
| `tmp` | `/tmp` | |
| `var/tmp` | `/var/tmp` | |
| `var/log` | `/var/log` | 3.1 GB |
| `var/cache/pacman/pkg` | | 23 GB |
| `var/abs` | | empty |
| `srv` | `/srv` | only empty dirs |
| `var/lib/machines`, `var/lib/portables` | | empty |

Other sizes: `/usr` 18 GB, `/opt` 5.2 GB, Arch's `/nix` 24 GB, Docker images
84 GB + build cache 38 GB + volumes 15 GB, `/root` 573 MB (caches).

Nested subvolumes are **not** included in a snapshot or `btrfs send` of their
parent. Backups of `home` must send `VirtualBox VMs` and `Nextcloud2`
separately (see migration plan).

## 1. Non-standard system configuration

### Power, suspend, hibernate

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| BE200 Bluetooth sleep hook | `/usr/lib/systemd/system-sleep/btintel-pcie` (hand-placed, no package): `modprobe -r btintel_pcie` before sleep, `modprobe btintel_pcie` after. Without it suspend/hibernate fails with `-EBUSY` and hangs | active | port (`powerManagement.powerDownCommands` / `resumeCommands` or a sleep hook unit) | |
| Lid handling | `logind.conf`: `HandleLidSwitch=suspend-then-hibernate`, `HandleLidSwitchExternalPower=suspend-then-hibernate`, `HandleLidSwitchDocked=ignore` | active | port (`services.logind.settings`) | |
| Suspend-then-hibernate | `sleep.conf`: `AllowSuspendThenHibernate=yes`, `HibernateDelaySec=60min`. Only `s2idle` is available on this machine | active, used daily | port (`systemd.sleep.extraConfig`) | |
| Hibernation | swapfile `/swap/swapfile` 32 GiB, `resume=/dev/mapper/cryptroot resume_offset=24751` | active | port (phase 4 of the migration plan) | |
| sleep-on-unplug | `/etc/systemd/system/sleep-on-unplug.service` + `/etc/udev/rules.d/60-sleep-on-unplug.rules` + `/usr/local/bin/sleep-on-unplug`: suspend-then-hibernate when AC is unplugged while docked with lid closed. Still in **dry-run** mode (`SLEEP_ON_UNPLUG_DRYRUN=1`); optionally uses `evtest` (not installed, falls back to `/proc/acpi`) | installed, dry run | decide | |
| tlp + `/etc/tlp.d/01-elitebook.conf` | EPP/max-perf/boost per AC/BAT/SAV, PCIe ASPM powersupersave on BAT, runtime PM, Wi-Fi power save, USB autosuspend | `tlp.service` enabled but **not running** (conflicts with power-profiles-daemon) | decide: tlp or ppd | |
| power-profiles-daemon | DMS uses it for its power profile switcher | **running** (D-Bus activated) | port (likely the one to keep) | |
| tlpui, tlp-rdw | GUI and radio device wizard for tlp | depends on tlp | decide | |
| zram | `zram-generator.conf`: `zram-size = min(ram / 2, 16384)` | active | port (`zramSwap`) | |
| Swappiness | `/etc/sysctl.d/99-swappiness.conf`: `vm.swappiness=10` | active | port (`boot.kernel.sysctl`) | |
| `msr.allow_writes=on` | kernel parameter, typically for undervolting/throttled tools; nothing on this machine uses it | set | drop | |
| acpi_call | ThinkPad ACPI calls (battery thresholds); not useful on HP | installed | drop | |
| powertop, acpi | diagnostics | installed | decide | |

### Boot, kernel, security

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| Kernels | `linux`, `linux-lts`, `linux-zen` + headers, `virtualbox-host-dkms` | 3 kernels | port one (`linuxPackages_latest`) | |
| Initramfs | mkinitcpio `encrypt keymap consolefont btrfs resume` | | port (systemd initrd, LUKS, `de-latin1`) | |
| AppArmor | `lsm=landlock,lockdown,yama,apparmor,bpf`; `apparmor.service` active; only package-provided profiles (plus enabled-but-missing `snapd.apparmor`) | active | decide | |
| Secure Boot | `sbctl` keys in `/var/lib/sbctl`, `shim` installed, Secure Boot **disabled** | unused | later (lanzaboote) | |
| Module blacklist | `/etc/modprobe.d/nobeep.conf`: `pcspkr`; `no-wwan.conf`: `mtk_t7xx` (no WWAN modem in this machine) | active | port `pcspkr`, decide `mtk_t7xx` | |
| kexec-tools | | installed | decide | |
| Console | `vconsole.conf`: `KEYMAP=de-latin1`, `FONT=ter-124b` | active | port | |
| Locale | `LANG=de_AT.UTF-8`; generated: `de_AT.UTF-8`, `en_US.UTF-8` | active | port | |
| X11 keyboard | `/etc/X11/xorg.conf.d/00-keyboard.conf`: layout `de` | | port (`services.xserver.xkb.layout`) | |
| Global env (`/etc/profile`) | `_JAVA_AWT_WM_NONREPARENTING=1`, `WINIT_X11_SCALE_FACTOR=1` | active | port (`environment.sessionVariables`) | |
| Global env (`/etc/environment`) | `OPENROUTER_API_KEY` | active | decide (secret, not in repo) | |
| sudo | `%wheel ALL=(ALL) NOPASSWD: ALL`, no `sudoers.d` | active | port (`security.sudo.wheelNeedsPassword = false`) | |
| Trusted CA | `/etc/ca-certificates/trust-source/anchors/`: "Caddy Local Authority - 2024 ECC Root" (2 certs, valid until 2034); CA data in `/root/.local/share/caddy` | active | decide (`security.pki.certificateFiles`) | |
| subuid/subgid | `root:100000:65536`, no userns-remap configured for Docker | unused | drop | |
| multipath | `/etc/multipath/bindings` (2022) | unused | drop | |
| PAM `system-auth` | marked modified, content matches stock Arch | | drop | |
| rtkit args | `/etc/sysconfig/rtkit` (custom realtime limits, 2023) | probably not read | drop | |

### Networking

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| NetworkManager connections | 37 files in `/etc/NetworkManager/system-connections`: 30 Wi-Fi (28 PSK/open, `eduroam` and `hslu` WPA-EAP/TTLS), 5 Ethernet, OpenVPN `work` (password+TLS, certs in `~/.cert/nm-openvpn/`), WireGuard `Home` (file `Alex-840G6.nmconnection`, no autoconnect) | active | data (copy the directory) | |
| NM dispatcher `30-samba-vpn.sh` | on work VPN up: `gio mount` of the work file share | installed | decide | |
| NM dispatcher `30-samba-wired.sh` | same for a wired connection, disabled with `exit 0` at the top | dead | drop | |
| NM dispatcher `delete-tun0-default-route.sh` | removes default route via `tun0` when it comes up | installed | decide | |
| networkmanager-dispatcher-chrony | toggles chrony online/offline with NM | active | port | |
| networkmanager-openvpn | | active | port | |
| WireGuard | `wireguard-tools`; `/etc/wireguard` is empty, the tunnel lives in NetworkManager | | port tools | |
| chrony | servers: work domain controllers (offline auto), arch pool, NTS servers (ptbtime1-3, nts1.time.nl, nts.ntp.se, nts.sth1/2.ntp.se, time.cloudflare.com), `rtcsync`, `rtconutc`, `makestep 1.0 3`, `leapsectz right/UTC` | active | port | |
| timedated override | `SYSTEMD_TIMEDATED_NTP_SERVICES=chronyd.service:systemd-timesyncd.service` | active | drop (NixOS chrony module handles it) | |
| `/etc/hosts` | `192.168.0.11 portainer.leidwein.com`, `192.168.67.11 PCNX-LeiAle1` | active | port (`networking.hosts`) | |
| ufw | rules allow (tcp+udp) 81, 2049, 3001, 4200, 8080, 8081; `ufw.service` enabled but `ENABLED=no` in `ufw.conf`, so **no firewall is active** today | inactive | port (`networking.firewall`), decide which ports | |
| sshd | enabled, `X11Forwarding yes`, otherwise stock | active | port | |
| SSH host keys | `/etc/ssh/ssh_host_*` (incl. legacy DSA) | | data (keeps known_hosts valid elsewhere) | |
| avahi | running (pulled in by cups) | active | port | |
| systemd-networkd | enabled, configs for `enp1s0`/`wlp2s0` (interfaces from an older machine, manages nothing now); `systemd-networkd-wait-online` times out on every boot | dead, slows boot | drop | |
| systemd-resolved | `resolved.conf`: `DNS=192.168.64.11`, service disabled | dead | drop | |
| iwd | `/etc/iwd/main.conf`, iwd not installed | dead | drop | |
| `openvpn-client@.service` | copy of upstream unit in `/etc`, no client configs | dead | drop | |
| NFS server | `/etc/exports` `/srv/nfs` + `steamapps` for 10.0.1.x, `nfs-server` disabled, dirs empty | dead | drop | |
| autofs | `/etc/autofs/auto.*` CIFS map (plaintext password), autofs not installed | dead | drop | |
| Samba AD join | `smb.conf` ADS member of the work domain, `krb5.keytab`, `winbind` in `nsswitch.conf`, `/var/lib/samba` (53 MB); winbind/smb not installed | dead | drop | |
| CIFS credentials | `/etc/samba/credentials/share` (2021); a script in `~/.scripts` mounts the work file share with a password prompt instead | | decide | |
| Kerberos | `/etc/krb5.conf` work realm and KDC | | decide | |

### Storage, backups

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| snapper | `root`: timeline 2 hourly / 7 daily / 4 monthly, 10 numbered; `etc`: same timeline, 50 numbered; `home`: timeline 10 hourly / 14 daily / 6 monthly, 50 numbered. All with `SPACE_LIMIT=0.5`, `FREE_LIMIT=0.2`. Cleanup timer override every 2h; `snap-pac` pre/post pacman snapshots for `root` and `etc` | active | port `home` only (NixOS generations replace root/etc) | |
| snap-sync, snapper-gui, snp | snapper helpers (external drive backup, GUI, wrap commands) | installed | decide | |
| btrbk | 3 identical configs from 2021, gpg-encrypted raw target on the work CIFS share, no timer | dead | decide | |
| btdu, ncdu | disk usage tools | | port | |
| nvme hostid/hostnqn | generated by nvme-cli | | drop | |

### Printing, scanning

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| Printer HP LaserJet 400 MFP M425dn | `socket://10.0.0.93`, generic "HP LaserJet Series PCL 4/5" driver (`rastertohp`, part of cups), not shared | configured | decide (`hardware.printers.ensurePrinters`) | |
| Printer Xerox WorkCentre 6515 | `socket://192.168.0.21`, not shared. The AUR "driver" `xerox-workcentre-6515-6510` is only a PostScript PPD (`xrx6515.ppd`, no filter binaries) | configured | decide (put the PPD in the repo, or driverless/IPP) | |
| sane-airscan | network scanners | installed | port | |
| system-config-printer | GUI | installed | port | |

### Desktop session

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| Login | no display manager; login on tty1, start Hyprland manually (`hyprland.desktop`, `hyprland-uwsm.desktop` installed) | active | decide (keep tty or add greetd) | |
| hyprmoncfg | AUR, user service `hyprmoncfgd` writes `hyprmoncfg-monitors.lua` | running | port (needs packaging) | |
| Hyprland autostart | `dms run`, `nextcloud --background`, `nm-applet`, `rbw-agent` (default + `work` profile), `wl-paste ... cliphist store`, `hyprpolkitagent` | active | port (mostly in flake already) | |
| `~/.config/autostart` | `ckb-next` (not installed), Nextcloud (twice), `remmina-applet` | | drop ckb-next, decide rest | |
| Bluetooth `main.conf` | `ControllerMode=dual`, `Privacy=off`, `JustWorksRepairing=always`, `MinEncryptionKeySize=7`, `SecureConnections=optional`, `AutoEnable=true` | active | decide (`hardware.bluetooth.settings`) | |
| Bluetooth pairings | `/var/lib/bluetooth` (speaker, headphones, mouse) | | data | |
| Fingerprint | `fprintd` installed, reader Elan `04f3:0c9f`, **no fingerprints enrolled** (`/var/lib/fprint` empty) | unused | decide | |
| Desktop support services | running as dependencies: accounts-daemon, upower, udisks2, geoclue, colord, passim (fwupd), xdg-desktop-portal-gtk | active | port (mostly enabled by NixOS modules) | |
| Headset udev rules | `/usr/local/lib/udev/rules.d/70-headsets.rules` + hand-built `/usr/local/bin/headsetcontrol` (2022) | installed | decide (`pkgs.headsetcontrol` ships the rules) | |
| VNC for X11 | `/etc/X11/xorg.conf.d/10-vnc.conf` (TigerVNC module) | dead (no X server) | drop | |
| gnome-keyring, xdg-user-dirs, mpris-proxy, pipewire/wireplumber | user units | active | port | |
| zsh | `zsh/.zshrc` is grml-based (needs `grml-zsh-config`), vi keys, fzf, syntax highlighting, autosuggestions, thefuck, `portfw`, `rh`, bun, fnm (`--use-on-cd --corepack-enabled`), zoxide, rbw `SSH_AUTH_SOCK`. `.zshenv`: `GCM_CREDENTIAL_STORE`, `EDITOR`, `XKB_DEFAULT_LAYOUT=de`, XDG dirs, `~/.scripts` in PATH, per-host `WLAN_INTERFACE`/`NETWORK_INTERFACE` | active | mostly already in `modules/features/shell.nix`; decide on vi mode, bun, fnm, grml, `~/.scripts` | |

### Virtualization, containers, development

| Item | Details | State | Suggestion | Decision |
|---|---|---|---|---|
| Docker | 29.8, `btrfs` storage driver, 214 images (84 GB), 324 containers (4 running: farmtracker), 78 volumes (15 GB), build cache 38 GB; `docker-buildx`, `docker-compose`, `docker-credential-secretservice`. All compose projects live in `~` (see §2) | active | port + data (volumes) | |
| VirtualBox | 7.2.16 + Oracle extension pack, VNC ext pack, guest additions ISO. `virtualbox` and `virtualbox-ext-oracle` are **pinned** via `IgnorePkg` in `pacman.conf` (host-dkms is already 7.2.20). VM `Windows 10` (74 GB, own subvolume `~/VirtualBox VMs`, last used 2026-09-15) | modules loaded | decide (why pinned?) | |
| libvirt | `/etc/libvirt` (pools `default` and `~/libvirt-vms/windows-10`, default network), `/var/lib/libvirt`; libvirt not installed | dead | drop | |
| libtpms | software TPM library | | decide (only for VMs) | |
| Nix on Arch | `nix-daemon`, empty user profile | | drop (NixOS replaces it) | |
| Android | `android-tools`, `android-udev`, `android-file-transfer`, `/opt/android-sdk` (manual, build-tools 34) | | decide | |
| Flutter | `/opt/flutter` (manual git checkout) | | decide | |
| Node in `/usr/local` | manual Node v26.7 in `/usr/local/bin` shadows `/usr/bin/node`, global `npm`, `corepack`/`pnpm`/`yarn`, `@angular/cli` (`ng`), `@opencode-ai/browser-control` (now in flake) | active | decide (fnm/devshells/flake instead) | |
| fnm | Node version manager, versions in `~/.local/share/fnm` | active | decide (needs `nix-ld`) | |
| bun | `~/.bun` | | decide | |
| pip `--user` tools | `~/.local/bin`: airflow, litellm, wandb, transformers-cli, huggingface-cli, flask, celery, ... (shebangs point at Arch's Python, will break) | | decide (`uv tool` / devshells) | |
| Global npm leftovers | `/usr/lib/node_modules`: neovim, http-server, tslint, nodemon, emmet-ls, @angular, @cyclonedx, jslint, @bitwarden, @electron (not owned by any package) | leftover | drop | |
| axctl | 6 MB binary in `/usr/local/bin` (2025-05) | unknown | decide | |
| Prospect Mail | `/usr/local/bin/prospect-mail` -> `/opt/Prospect Mail` (target missing) | dead | drop | |
| `/opt` leftovers | `pycharm-professional` (4.7 MB remnant), `WiFiman Desktop`, empty `containerd` | leftover | drop | |
| Other unowned files | `/usr/share/webapps/sonarqube`, `/usr/share/.mono`, cursor themes (volantes, GoogleDot-Blue, Vimix), inkscape remnants, old `ibt-*.sfi` BT firmware | leftover | drop | |
| `/var/lib` leftovers | `mlocate` (2 GB old database), `devolonetsvc` (47 MB), `snapd` (20 MB), `texmf` (199 MB), `waydroid`, `rabbitmq`, `caddy`, `openldap`, `pgadmin`, `sss`, `iwd`, `postgres` (empty `data`), `/srv/deluge` (empty) | leftover | drop | |
| plocate | database is 1.1 GB (indexes snapshots, Docker, Nix store) | active | port with `prunePaths` | |
| `/root` | shell history, caches, `.android`, Caddy local CA data, old xmonad/nvim/kitty configs | | drop (keep Caddy CA if the trusted root stays) | |

### Hardware observations

| Item | Details | Suggestion | Decision |
|---|---|---|---|
| Camera | HP 5MP, USB UVC (`0408:5474`), `/dev/video0-3` | works out of the box | |
| Speakers | Cirrus CS35L56 amps; kernel logs `failed to add SPI device CSC3554:00` at boot | check speakers on NixOS | |
| Sensor hub | `intel_ish_ipc: ISH loader: cmd 2 failed` (HP ISH firmware missing) | check if sensors matter | |
| NPU | `intel_vpu` loaded | decide (firmware/userspace only if used) | |
| Wi-Fi regulatory | `regulatory.db` missing (`wireless-regdb` not installed) | port (`hardware.wirelessRegulatoryDatabase`) | |
| Graphics | Arc 140V on `xe` driver | port | |

### Things in `/home` that break on NixOS

`/home` is shared as-is, but a few things in it point at Arch paths:

| Item | Details | Suggestion | Decision |
|---|---|---|---|
| `~/.scripts` | 5 of 7 scripts use `#!/bin/bash` (NixOS has no `/bin/bash`) | decide (`services.envfs` or `#!/usr/bin/env bash`) | |
| `mpris-proxy` user unit | `~/.config/systemd/user/mpris-proxy.service` hardcodes `/usr/bin/mpris-proxy` | port (`services.mpris-proxy` in Home Manager), remove the unit | |
| Desktop files | `~/.local/share/applications`: Chrome app, `claude-code-url-handler`, tutanota, Telegram reference `/opt` or `/usr/bin` | decide | |
| pip `--user` tools | `~/.local/bin` (see above) | decide | |
| `~/.nix-profile` | points at Arch's `/nix/var/nix/profiles/per-user/alex/profile` | drop | |

## 2. State to carry over (independent of decisions above)

- `/home` (shared subvolume, no copy needed)
- NetworkManager connections (`/etc/NetworkManager/system-connections`, 37 files)
- SSH host keys (`/etc/ssh/ssh_host_*`)
- Bluetooth pairings (`/var/lib/bluetooth`)
- Docker volumes (`/var/lib/docker/volumes`), named ones by compose project:

  | Project (working dir) | Volumes | Size |
  |---|---|---|
  | farmtracker (`~/projects/mobileapp/FarmTracker`) | `db-data`, `matomo-db-data`, `matomo-data` | 590 MB |
  | timelit-langfuse (`~/git/timelit`) | clickhouse data/logs, postgres, minio, redis | 1.3 GB |
  | boutique-hotel-technikum-2024-ac (`~/git/...`) | `mysql_data` | 200 MB |
  | kafka, kafka-dev (`~/git/bier-in-aktion/kafka`) | `kafka-1..3-data`, `web-db-data` | 250 MB |
  | portal, homepage (`~/projects/homepage`) | `db-data`, `keydb-data` | 130 MB |
  | projects, lobster-learn, tool, mobileapp | `db-data` each | 190 MB |
  | elastic, teleport, trek, dns | small | < 10 MB |
  | not compose | `buildx_buildkit_mybuilder0_state` (9.3 GB), `nix-store-tmp` (1.2 GB), `gitops-nix` (1.2 GB), `technitium_config`, `nomad_*` | |
  | anonymous | ~30 hash-named volumes, up to 67 MB each | |

  Containers only bind-mount paths in `~`, `/var/run/docker.sock`,
  `/tmp/.X11-unix` and the PulseAudio socket.
- sbctl keys (`/var/lib/sbctl`: PK, KEK, db), if Secure Boot is planned
- CUPS printers (recreate declaratively; PPDs are in `/etc/cups/ppd`)
- Caddy local CA (`/root/.local/share/caddy`), if the trusted root is kept

## 3. Installed packages (268 explicit)

Legend: ✓ already provided by the flake (shared modules or `users/alex/home.nix`),
**P** only in `system/PCNX-LeiAle1/configuration.nix` (needs to move to a shared
module or be repeated), → to port, ✗ not needed on NixOS.

### Desktop / Hyprland

| Package | Status | Decision |
|---|---|---|
| hyprland, hyprlock, hyprpolkitagent, grimblast, cliphist, playerctl, pamixer, brightnessctl | ✓ | |
| dms-shell, quickshell, matugen | ✓ (dms module) | |
| hyprmoncfg | → needs packaging | |
| hyprpicker, wtype, xdg-desktop-portal-hyprland | → | |
| bemenu | ✓ | |
| fuzzel (bound to `Super+Shift+P`, not installed on Arch) | ✓ (`home.nix`) | |
| alacritty | ✓ | |
| network-manager-applet, blueman | ✓ / → | |
| udiskie, pcmanfm | ✓ | |
| gnome-keyring, xdg-user-dirs | **P** / → | |
| adw-gtk-theme, papirus-icon-theme, lxappearance, bibata-cursor-theme | → / → / decide / ✓ | |
| gnome-font-viewer, gnome-network-displays | decide | |
| feh | decide | |
| gpu-screen-recorder | → (`programs.gpu-screen-recorder`) | |
| xclip, xorg-xauth | ✓ / decide | |

### Apps

| Package | Status | Decision |
|---|---|---|
| zen-browser, helium-browser | ✓ | |
| thunderbird | → | |
| signal-desktop | → | |
| nextcloud-client | ✓ | |
| libreoffice-fresh (+ de, en-gb), mythes-de/en, libmythes | ✓ (`libreoffice-stable`), → hunspell/hyphen de | |
| gimp, mypaint-brushes | decide | |
| zathura | ✓ | |
| remmina | ✓ | |
| rustdesk | decide | |
| bitwarden (GUI), bitwarden-cli, rbw | → / decide / ✓ | |
| yubico-authenticator | → (+ `services.pcscd`) | |
| steam, mangohud | ✓ | |
| postman | decide | |
| datagrip | ✓ | |
| lens | ✓ | |
| stopwatch | decide | |
| claude-code, opencode2, opencode-desktop | ✓ | |
| opencode (v1) | ✗ (replaced by opencode2) | |
| herdr | ✓ | |

### CLI / dev tools

| Package | Status | Decision |
|---|---|---|
| git, git-lfs, git-credential-manager, jujutsu | ✓ | |
| github-cli, glab | → | |
| neovim, tree-sitter-cli, python-pynvim | ✓ (neovim module) / decide | |
| gcc, go, nodejs, npm, uv, opentofu | ✓ | |
| go-tools, gopls | → | |
| jdk-openjdk | decide | |
| python312, python-pip, python-pipx, python-poetry | decide | |
| lua54 | decide | |
| fnm | decide | |
| kubectl, sops, age | ✓ | |
| azure-cli, azure-dev-cli (azd) | → | |
| syft | decide | |
| repo | decide | |
| starship, fzf, zoxide, fd, ripgrep, fastfetch, pwgen, tmux, htop, calc, tree, wget | ✓ | |
| thefuck | ✓ (replaced by `pay-respects`) | |
| bat, hyperfine, progress, sloc, ncdu, btdu | → / decide | |
| websocat, gnu-netcat, nmap, nload, traceroute, whois, bind (dig), net-tools | → / decide | |
| sshfs, smbclient, nfs-utils, ntfs-3g | → | |
| rsync, zip, unzip, mbuffer, liblzf | → / ✓ | |
| nvme-cli, perf, powertop, intel-gpu-tools, libva-utils, clinfo, mesa-utils | → / decide | |
| ddcutil | → (`hardware.i2c`) | |
| zsh, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions | ✓ (HM zsh) | |
| grml-zsh-config | decide (current `.zshrc` depends on it) | |
| stow | ✗ after migration | |
| base-devel, autoconf, automake, bison, flex, m4, libtool, make, patch, patchelf, pkgconf, fakeroot, binutils, gettext, groff, texinfo | ✗ (use devshells), decide if any wanted globally | |

### System services and drivers

| Package | Status | Decision |
|---|---|---|
| docker, docker-buildx, docker-compose, docker-credential-secretservice | **P** / → | |
| virtualbox, virtualbox-ext-oracle, virtualbox-ext-vnc, virtualbox-guest-iso, virtualbox-host-dkms | **P** / decide | |
| bluez, bluez-utils | → | |
| fprintd, fwupd | decide (nothing enrolled) / → | |
| tlp, tlp-rdw, tlpui, power-profiles-daemon | decide (see §1) | |
| chrony, networkmanager-dispatcher-chrony, networkmanager-openvpn, wireguard-tools | → | |
| openssh | **P** | |
| ufw, iptables | ✗ (`networking.firewall`) | |
| apparmor | decide | |
| sane-airscan, system-config-printer, xerox-workcentre-6515-6510 | → / → / decide | |
| snapper-gui, snap-sync, snp, snap-pac, btrbk | decide / ✗ snap-pac | |
| plocate, man-db | → | |
| sbctl, shim | later | |
| kexec-tools, acpi, acpi_call | decide / decide / ✗ | |
| intel-media-driver, intel-compute-runtime, vulkan-intel, mesa | → (`hardware.graphics`) | |
| linux-firmware, sof-firmware, intel-ucode | → (`hardware.enableRedistributableFirmware`, microcode) | |
| pipewire-alsa, pipewire-jack, pipewire-pulse, pipewire-docs | **P** | |
| zram-generator | → (`zramSwap`) | |
| android-tools, android-udev, android-file-transfer | decide | |
| libtpms | decide | |
| nix | ✗ | |
| terminus-font | → (console font) | |

### Fonts

| Package | Status | Decision |
|---|---|---|
| ttf-firacode-nerd, ttf-hack, ttf-ms-fonts | **P** (nerd-fonts fira-code/hack, corefonts) | |
| ttf-fira-code, ttf-nerd-fonts-symbols, ttf-roboto-mono, ttf-liberation, ttf-croscore, ttf-caladea, ttf-carlito | → | |
| noto-fonts, noto-fonts-cjk, noto-fonts-emoji, noto-fonts-extra | → | |
| adobe-source-sans-fonts, ttf-sourcesanspro, ttf-poppins, ttf-league-gothic | decide | |
| otf-font-awesome, ttf-material-design-icons, ttf-phosphor-icons | → (check what DMS/waybar themes use) | |

### Arch-only, nothing to port

`base`, `pacman`, `paru`, `paru-debug`, `downgrade`, `etc-update`, `expac`,
`pacdep`, `reflector`, `kernel-modules-hook`, `systemd-boot-pacman-hook`,
`pacman-boot-backup-hook`, `snap-pac`, `neovim-symlinks`, `linux-headers`,
`linux-lts`, `linux-lts-headers`, `linux-zen`, `linux-zen-headers`,
`virtualbox-host-dkms`, `sudo`, `which`, `file`, `findutils`, `gawk`, `grep`,
`gzip`, `sed`.

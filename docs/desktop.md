# Desktop: Hyprland and mango

Every host has two Wayland compositors, Hyprland and mango (mangowm), both
with DankMaterialShell (DMS) as bar, launcher and notifications. There is no
greeter on LTNX-LeiAle1 and PCNX-LeiAle1: log in on a TTY and start one.
On TR, GDM lists both as sessions.

| | Hyprland | mango |
|---|---|---|
| Start from a TTY | `start-hyprland` | `mango` |
| Feature | `modules/features/hyprland.nix` | `modules/features/mango.nix` |
| Package | nixpkgs (`programs.hyprland`) | flake input `mangowm` (`programs.mango`) |
| Config | `configs/hyprland/.config/hypr/hyprland.lua` | `configs/mango/.config/mango/config.conf` |
| Monitors | `modules/hosts/<host>/monitors.lua`, hyprmoncfg on LTNX-LeiAle1 | `modules/hosts/<host>/monitors.conf`, DMS display settings on LTNX-LeiAle1 |

## Keybindings and autostart

Both configs have the same keybindings and start the same programs (polkit
agent, `dms run`, Nextcloud, nm-applet, netbird-ui, the two rbw agents, the
cliphist watchers). A change to one belongs in the other too.

Differences in mango:

- Workspaces are tags: `SUPER+<n>` views tag n, `SUPER+SHIFT+<n>` moves the
  window there without following it.
- The area screenshot (`SUPER+SHIFT+s`) uses `slurp` + `grim` and can't
  freeze the screen; it is saved to `~/Pictures/screenshots/` and copied to
  the clipboard.
- The active border is a single colour (no gradient).

## Session start

`mango` sets up the session itself: it imports `WAYLAND_DISPLAY`,
`XDG_CURRENT_DESKTOP` and friends into systemd and dbus and starts
`graphical-session.target` (via `mango-session.target`), so the portals
work. `config.conf` sets `XDG_SESSION_TYPE=wayland`, which stays `tty` after
a TTY login otherwise.

Hyprland runs without UWSM, so nothing starts `graphical-session.target`
there. DMS is therefore started by each compositor's config (`dms run`), not
by its systemd unit.

## DMS

DMS is its own feature (`modules/features/dms.nix`, in `profile-default`);
its settings live in `configs/hyprland/.config/DankMaterialShell/`
(out-of-store link, DMS writes there).

Under mango, DMS writes fragments to `~/.config/mango/dms/` (theme colours,
layout, cursor, display settings). `config.conf` sources them with
`source_optional` before its own settings, so the repo's options win; DMS's
keybinding fragment isn't sourced. `~/.config/mango` is linked per file, so
the directory itself stays writable. Check the config with
`mango -p -c ~/.config/mango/config.conf`; mango also reloads it on change.

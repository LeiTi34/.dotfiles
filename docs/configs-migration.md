# Migrating a machine to the configs/ layout

The dotfiles moved from `<app>/` to `configs/<app>/`. Until a machine is
migrated, its links into the repo point at the old paths: on Arch the stow
links, on NixOS the out-of-store links (`~/.config/nvim`, `~/.config/DankMaterialShell`,
`~/.config/hypr/hyprmoncfg-monitors.lua`) and any leftover stow or manual
links. Progress per machine: `docs/todo.md` ("configs/ migration").

Do the steps in one go: between pulling and the rebuild or restow, nvim, DMS
and hyprmoncfg have no config. Don't change DMS settings or monitor layouts in
between, they would be written through a dangling link and recreate the old
folders.

## 1. Pull and move the leftover files (all machines)

A pull only moves tracked files. Gitignored runtime files (DMS plugins and
state, `hypr/dms`, `hypr/monitors.lua`, opencode's `node_modules`, ...) stay in
the old folders and have to be moved by hand:

```sh
cd ~/.dotfiles
git pull                      # or: jj git fetch && jj new master
for d in alacritty ghostty hyprland latexmk librewolf nvim opencode picom \
         polybar qtile river ssh xmonad zsh; do
  [ -d "$d" ] || continue
  find "$d" -type f -o -type l    # what's left, check it
  cp -an "$d"/. "configs/$d"/     # -n: never overwrite the tracked files
  rm -r "$d"
done
git status --short                # / jj st: nothing new, nothing missing
```

`nvim/.config/nvim/snippets/vscode-angular-snippets` (a removed submodule)
can be deleted instead of copied.

## 2a. NixOS (LTNX-LeiAle1, PCNX-LeiAle1)

1. List the links into the repo that Home Manager doesn't manage (old stow
   links, the manual `~/.config/DankMaterialShell`):
   ```sh
   find ~ -maxdepth 4 -xdev -path ~/.cache -prune -o -type l -lname '*dotfiles*' -printf '%p -> %l\n'
   ```
   Home Manager's links point into `/nix/store` and don't show up. Delete
   the listed ones with `rm <link>` (removes only the link) after checking
   that the program isn't used on this machine; if it is, it needs a feature
   in `modules/`.
2. Rebuild: `nixos-rebuild switch --flake .#<host> --sudo`.

## 2b. Arch (TR, X1C6)

1. Note which folders were stowed (the `STOW_FOLDERS` default in `arch` is
   `alacritty,nvim,zsh,hyprland,opencode,ssh`; check the shell environment
   and the dangling links below for others).
2. Delete the stow links that broke with the move:
   ```sh
   find ~ -maxdepth 4 -xdev -path ~/.cache -prune -o -xtype l -lname '*.dotfiles/*' -print -delete
   ```
3. Restow: `STOW_FOLDERS=<folders> ./arch`.

## 3. Check (all machines)

- `nvim` starts with its config, Hyprland and DMS keep their settings
  (bar, theme, plugins), the monitor layout is applied.
- No broken links into the repo:
  `find ~ -maxdepth 4 -xdev -path ~/.cache -prune -o -xtype l -lname '*dotfiles*' -print`
- `git status` / `jj st` in `~/.dotfiles` shows no changes.
- Tick the machine off in `docs/todo.md`.

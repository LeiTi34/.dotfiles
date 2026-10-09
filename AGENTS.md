# AGENTS.md

Config repo for my workstations: a NixOS flake (`modules/`, `system/`,
`users/`) with Home Manager, plus the dotfiles in stow layout (`<app>/`).
[README.md](README.md) gives the overview; `docs/` explains the details. This
file holds the rules for making changes.

## Read the docs first

- Before any change or investigation, read the README and the `docs/` files
  for the area you touch (the README's table lists them). Don't rely on
  memory or on this file alone.
- If the docs and the code disagree, the code (or the live machine) wins: say
  so and fix the docs in the same change.
- A change that alters how something works updates the matching doc in
  `docs/`. New topics get a section in the fitting doc, or a new doc linked
  from the README's table.

## Documentation and comments

- Comments, docs, README.md and AGENTS.md describe the current state, they
  are not a changelog; history belongs in git. No "x was changed to y because
  of z", "no longer", "used to", "migrated from", "since <date>". Write y, or
  "y because z" when the reason isn't obvious.
- The code is the documentation. Document only what isn't obvious from it:
  exceptions, non-obvious reasons, procedures, workarounds for hardware or
  firmware bugs.
- In-depth explanations go into `docs/`; README.md stays a high-level overview
  with links; AGENTS.md only holds instructions and conventions. Open tasks go
  into `docs/todo.md`.
- Match the comment density of the surrounding code; reference docs as
  `docs/<file>.md` (section), not the README.

## Ground rules

- Commit your changes yourself (see [Commit messages](#commit-messages)), but
  never push. Print the push for the user at the end:
  `jj bookmark set master -r <change> && jj git push`.
- Don't switch the running system unless the user asks for it; validate with
  `nix flake check --no-build` and print the apply command instead:
  `nixos-rebuild switch --flake .#<host> --sudo` (or `boot` for kernel,
  initrd and bootloader changes). Use `--sudo`, not `sudo nixos-rebuild`:
  private inputs are fetched over SSH with the user's agent.
- **The repo is public.** No secrets and no personal data: account emails,
  usernames, work hostnames and URLs, device serials, MAC addresses, private
  keys. Check the diff before every commit. Machine-local or private config
  is set imperatively (e.g. `rbw config set`) or lives in untracked files
  (e.g. `~/.ssh/config.d/*.conf`); the repo only references it.
- Never print secrets. Don't read vault entries (`rbw get`, `rbw code`) or
  private keys unless the task needs exactly that entry.
- Files a program writes at runtime (caches, generated themes, state markers,
  downloaded plugins) are gitignored, not committed.

## NixOS (modules/, system/)

- Follow the dendritic layout (flake-parts + import-tree + flake-file):
  every `.nix` under `modules/` is a flake-parts module. Plain NixOS files of
  one machine go into `system/<host>/`, the Home Manager config shared by all
  hosts into `users/alex/home.nix`.
- One program or topic per feature, `modules/features/<name>.nix`, defining
  `flake.modules.nixos.<name>`; the Home Manager part is
  `flake.homeModules.<name>`, imported for `profiles.primaryUser` (pattern:
  `modules/features/gh.nix`). Options where hosts need different values.
- A feature every workstation should get goes into
  `modules/profiles/workstation.nix`; otherwise into the host's list in
  `modules/hosts/<host>.nix`. Settings that only make sense on one machine
  (hardware, disks, boot, hostname) go into `system/<host>/`.
- `flake.nix` is generated: an input belongs to the feature that uses it
  (`flake-file.inputs.<name>`), core inputs to `modules/flake-file.nix`. Then
  `nix run '.#write-flake'` and `nix flake lock` (or
  `nix flake update <input>` for just that input). Full updates
  (`nix flake update`) are a commit of their own.
- The system's nixpkgs is `nixos-26.05`; Home Manager and most app inputs
  follow `nixpkgs-unstable`. Never change `system.stateVersion`.
- The flake only sees files jj tracks: run a jj command (e.g. `jj st`) after
  adding files, before evaluating.
- Validate with `nix flake check --no-build`. After touching a feature or the
  profile, check that the toplevel of hosts that shouldn't change stayed the
  same (`nix eval --raw '.#nixosConfigurations.<host>.config.system.build.toplevel'`
  before and after).
- 840G6 boots with lanzaboote (Secure Boot) and unlocks LUKS with TPM2 + PIN
  (`docs/secure-boot.md`). Never touch `/var/lib/sbctl` or the LUKS key
  slots. For kernel, initrd and bootloader changes tell the user that the
  previous generation stays selectable in the boot menu.

## Dotfiles (<app>/)

- Each `<app>/` folder is laid out like `$HOME` (a stow package). The NixOS
  hosts link it through the app's feature, either copied into the store
  (`source = ../../<app>/...`, applied by a rebuild, read-only) or as an
  out-of-store symlink (`mkOutOfStoreSymlink`, e.g. `nvim`, live). Two Arch
  machines stow the same folders with `./arch`, so a change reaches them too:
  keep the files working there.
- Don't run stow on a NixOS host; Home Manager owns those links.

## Commit messages

Agents commit their work when a task is done, split into atomic commits, with
jj (colocated repo): `jj commit -m '<message>' <paths>` commits only those
paths and leaves the rest in the working copy. Never move bookmarks or push.
Format: `<type>(<scope>): <subject>`, **always in English** (subject and body).

| Type | Usage |
|------|-------|
| `feat` | a new feature, program or host setting |
| `fix` | correcting a broken configuration, a typo, or a workaround for a bug |
| `chore` | routine work: flake updates, refactoring, cleanup |
| `docs` | README.md, AGENTS.md, `docs/`, inline comments |

| Scope | Path |
|-------|------|
| `<host>` | `modules/hosts/<host>.nix`, `system/<host>/` (`840G6`, `PCNX-LeiAle1`) |
| `<feature>` | `modules/features/<feature>.nix` (`docker`, `bitwarden`, `smart-bulb`) |
| `workstation` | `modules/profiles/workstation.nix` |
| `<app>` | the dotfiles folder (`nvim`, `zsh`, `hyprland`), or the program inside it when clearer (`dms`) |
| `flake` | `flake.nix`, `flake.lock`, `modules/flake-file.nix`, `modules/configurations/` |
| `repo` | root-level files and `docs/` (`README.md`, `AGENTS.md`, `.gitignore`, `arch`, `install`) |

```
feat(colmena): add colmena
fix(840G6): work around BIOS 01.06.02 hibernate bugs
chore(flake): update inputs
docs(repo): add README and AGENTS.md
```

- **Atomic commits.** One scope per commit. A new feature and the host or
  profile entries that enable it are one commit with the feature's scope.
- **Context is king.** For non-obvious changes, explain *why* in the commit
  body, especially for workarounds (what broke, how it was reproduced).

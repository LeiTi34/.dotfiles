# .dotfiles

Config for my workstations: a NixOS flake with Home Manager for the NixOS
machines, and the dotfiles themselves in stow layout, which the Arch machines
stow and the NixOS machines link through Home Manager. The servers live in a
separate repo (`gitops`). Public remote: `https://github.com/LeiTi34/.dotfiles`

| Host | Machine | Notes |
|---|---|---|
| 840G6 | HP EliteBook laptop | Secure Boot, TPM2 + PIN unlock, hibernation |
| PCNX-LeiAle1 | desktop, NVIDIA | |

## Layout

```
flake.nix               # generated from the flake-file.inputs in modules/
flake.lock
modules/                # flake-parts modules, all imported via import-tree
  flake-file.nix        # core inputs (nixpkgs, home-manager)
  configurations/nixos.nix  # configurations.nixos.<host> → nixosConfigurations
  features/<name>.nix   # one program or topic: flake.modules.nixos.<name>
                        # (+ flake.homeModules.<name> for the Home Manager part)
  profiles/workstation.nix  # the features every workstation gets
  users/alex.nix        # the primary user and the Home Manager config shared
                        # by all hosts (profiles.primaryUser)
  hosts/<host>.nix      # host = workstation profile + its own features
  hosts/<host>/*.nix    # only what belongs to this one machine (hardware, boot,
                        # printers, ...), added to configurations.nixos.<host>.module
<app>/                  # dotfiles of one program, laid out like $HOME
                        # (nvim, zsh, hyprland, alacritty, opencode, ...)
arch, install, clean-env  # (un)stow the <app>/ folders on Arch ($STOW_FOLDERS)
docs/                   # documentation
```

## Common tasks

- Apply on the current host: `nixos-rebuild switch --flake .#<host> --sudo`.
- Add a program: a feature in `modules/features/`, listed in the host or in
  `modules/profiles/workstation.nix`.
- Change flake inputs: edit `flake-file.inputs` (in the feature or
  `modules/flake-file.nix`), then `nix run '.#write-flake'` and
  `nix flake lock`. Update everything: `nix flake update`.
- Validate: `nix flake check --no-build`.
- Arch machine: `./arch` stows the folders in `$STOW_FOLDERS`.
- Commits: `<type>(<scope>): <subject>` ([AGENTS.md](AGENTS.md#commit-messages)).

## Documentation

| Doc | Contents |
|---|---|
| [docs/secure-boot.md](docs/secure-boot.md) | Secure Boot with lanzaboote and sbctl, fwupd under Secure Boot |
| [docs/todo.md](docs/todo.md) | open tasks |
| [docs/attic/](docs/attic/) | configs from Arch that aren't ported (yet) |

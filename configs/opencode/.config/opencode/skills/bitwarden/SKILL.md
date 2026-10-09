---
name: bitwarden
description: Fetch passwords, API tokens, TOTP codes and other secrets from the user's Bitwarden vaults via the `rbw` CLI. Use whenever a task needs a credential (login, token, key, connection string) or mentions Bitwarden, the vault, rbw, or the work/personal password manager. Also explains how SSH keys are served from the vault.
---

# Bitwarden via rbw

The user keeps secrets in two self-hosted Bitwarden (Vaultwarden) vaults, both
accessed with `rbw`. Never use the official `bw` CLI.

| Vault    | Command prefix           |
| -------- | ------------------------ |
| personal | `rbw ...` (default)      |
| work     | `RBW_PROFILE=work rbw ...` |

If you don't know which vault holds an entry, search personal first, then work.

## Finding entries

```sh
rbw search <term>              # matching entries (name, user, folder, uris)
rbw ls --fields name,user,folder
RBW_PROFILE=work rbw search <term>
```

These are safe to run freely; they never print secrets.

## Reading secrets

Every `rbw get` / `rbw code` asks the user for approval. Request exactly the
entry and field you need.

```sh
rbw get <name>                     # password
rbw get <name> <username>          # disambiguate by username
rbw get --folder <folder> <name>
rbw get --field <field> <name>     # custom field, e.g. "api key"
rbw code <name>                    # current TOTP code
```

Rules:

- **Never print a secret** to the conversation or logs. Pass it directly into
  the command that needs it:
  ```sh
  curl -H "Authorization: Bearer $(rbw get --field token 'Some API')" ...
  some-cli login --password-stdin <<<"$(rbw get 'Some service')"
  ```
- Don't write secrets to files, the clipboard, shell history, or commit them.
- Avoid `--full` and `--raw`; they dump every field. Use `--field` instead.
- `rbw add|edit|rm|generate|purge|config` are denied. If an entry needs to be
  created or changed, tell the user.

## Locked vault

The vault auto-locks after an hour. When locked, any `rbw` command pops up a
GUI password prompt for the user and blocks until they answer. If a command
hangs or fails with a pinentry/unlock error, stop and ask the user to unlock
(`rbw unlock` or `RBW_PROFILE=work rbw unlock`). Never ask for or handle the
master password yourself.

## SSH

SSH keys live in the vaults and are served by `rbw-agent`:

- `SSH_AUTH_SOCK` points to the personal vault's agent, so plain `ssh host`
  just works.
- Work hosts are configured in `~/.ssh/config.d/` with
  `IdentityAgent $XDG_RUNTIME_DIR/rbw-work/ssh-agent-socket`.
- Use `ssh`, `scp`, `rsync` normally; there is no need to fetch private keys.
  Never run `rbw get --field private_key`.

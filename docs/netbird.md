# NetBird client

The `netbird` feature (in `profile-development`) connects the host to the home
NetBird as one of alex's devices. The control plane runs at home
(`https://netbird.leidwein.com`, gitops repo, `docs/netbird.md`); alex's
devices land in the group `devices`, which reaches the home LAN
(`192.168.0.0/24`, `192.168.1.0/24`) and gets the LAN DNS for `leidwein.com`
(Technitium), from anywhere. Its dashboard is `https://nb.leidwein.com`: the
client resolves `netbird.leidwein.com` itself through the network's own DNS,
so on a NetBird device that name only serves the API and login, not the UI.

- The module's default client: unit `netbird`, CLI `netbird`, tray app
  "NetBird @ netbird" (`netbird-ui`, started by `hyprland.lua`), interface
  `wt0`, WireGuard on UDP 51820 (opened in the firewall for direct
  connections).
- Package and NixOS module come from nixpkgs-unstable, so the client stays on
  the server's NetBird release.
- Runs as root, not hardened: the hardened client only sets DNS through
  systemd-resolved, and these hosts use resolvconf.
- Network monitor on (`config.NetworkMonitor`, off by default on Linux): the
  client becomes the system resolver and forwards names outside
  `leidwein.com` to the DNS servers of the network it started on. Without the
  monitor it keeps those after a network change (e.g. home's `192.168.0.11`,
  only reachable through the tunnel, at work), every lookup fails, and it
  can't reach its own management either. With it, the client restarts its
  engine on network changes.

## Login

Once per host:

```sh
netbird up
```

It opens the login page in the browser (Keycloak or the local account). The
unit starts at every boot and reconnects with the stored login
(`/var/lib/netbird`). Check with `netbird status -d`: peers, relay,
routes (`192.168.0.0/24`) and the nameserver group. Logs:
`journalctl -u netbird`.

A host that ran the client under the name `home` (unit `netbird-home`)
keeps its old login and peer in `/var/lib/netbird-home`: after the rebuild,
log in again with `netbird up`, delete the old peer in the dashboard, then
`sudo rm -r /var/lib/netbird-home /etc/netbird-home`.

## AI gateway

`ai.leidwein.com` is 9router's API through NetBird's Agent Network (gitops
`docs/ingress.md`). It's only reachable with NetBird connected and needs no
key: OpenCode's `9router` provider sends a placeholder, which NetBird
replaces. 9router sets the Claude prompt-cache markers itself, so the `cc/`
models need no `cacheFormat`.

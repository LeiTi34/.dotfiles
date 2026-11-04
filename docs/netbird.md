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
- Runs as root, not hardened.
- Network monitor on (`config.NetworkMonitor`, off by default on Linux): the
  client restarts its engine when the default route changes (another
  network).

## DNS

The feature enables systemd-resolved; NetworkManager then hands its DNS to
resolved too, per link. NetBird's resolver listens on its `wt0` address and
sets on `wt0` only the match domain `~leidwein.com` with `DefaultRoute=no`.
Everything else goes to the DNS of the other links: the network's DNS, and a
VPN's DNS for its own domains (e.g. the work OpenVPN on `tun0`), also when
the VPN connects after NetBird.

Without resolved (resolvconf), NetBird registers itself as the only
nameserver in `/etc/resolv.conf` and forwards all other names to the servers
it read from that file at its start. It never re-reads them, so a VPN that
connects later doesn't get its DNS (internal names give NXDOMAIN), and after
a network change without a restart every lookup can fail.

Check with `resolvectl status` (per link: DNS servers and domains) and
`resolvectl query <name>` (which link answered).

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

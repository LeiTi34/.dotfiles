# NetBird client

The `netbird` feature (in `profile-development`) connects the host to the home
NetBird as one of alex's devices. The control plane runs at home
(`https://netbird.leidwein.com`, gitops repo, `docs/netbird.md`); alex's
devices land in the group `devices`, which reaches the home LAN
(`192.168.0.0/24`, `192.168.1.0/24`) and gets the LAN DNS for `leidwein.com`
(Technitium), from anywhere. Its dashboard is `https://nb.leidwein.com`: the
client resolves `netbird.leidwein.com` itself through the network's own DNS,
so on a NetBird device that name only serves the API and login, not the UI.

- Client `home`: unit `netbird-home`, CLI `netbird-home`, tray app
  "NetBird @ netbird-home" (`netbird-ui-home`), interface `nb-home`,
  WireGuard on UDP 51821 (opened in the firewall for direct connections).
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
netbird-home up
```

It opens the login page in the browser (Keycloak or the local account). The
unit starts at every boot and reconnects with the stored login
(`/var/lib/netbird-home`). Check with `netbird-home status -d`: peers, relay,
routes (`192.168.0.0/24`) and the nameserver group. Logs:
`journalctl -u netbird-home`.

## AI gateway

`ai.leidwein.com` is a LAN-only router at home (9router's API), reached
through NetBird. Clients send a 9router API key, one per client, created in
the 9router dashboard (`https://9router.leidwein.com`). OpenCode's provider
`9router` reads it from `~/.config/opencode/9router-key`, which isn't tracked;
Home Manager creates it empty if it's missing, because OpenCode refuses to
load its config when a `{file:...}` reference doesn't exist. On the Arch
machine, create the file by hand.

{ inputs, ... }:
{
  # Joins the home NetBird (home LAN, its DNS) with the login from
  # `netbird up`: docs/netbird.md.
  flake.modules.nixos.netbird =
    { pkgs, ... }:
    let
      unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      # The client follows the server's NetBird release; the system nixpkgs
      # lags behind, and its module's UI wrapper only fits the older UI.
      disabledModules = [ "services/networking/netbird.nix" ];
      imports = [ "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/netbird.nix" ];

      # The default client: unit and CLI `netbird`, interface wt0, UDP 51820,
      # not hardened (the hardened client only sets DNS through
      # systemd-resolved; these hosts use resolvconf).
      services.netbird = {
        enable = true;
        package = unstable.netbird;
        ui.package = unstable.netbird-ui;
        ui.enable = true;
        # The home LAN is a network route.
        useRoutingFeatures = "client";

        clients.default = {
          environment.NB_MANAGEMENT_URL = "https://netbird.leidwein.com";
          # Off by default on Linux: the client then keeps the DNS servers of
          # the network it started on, so after a network change every lookup
          # (its own management name included) can fail: docs/netbird.md.
          config.NetworkMonitor = true;
        };
      };
    };
}

{ inputs, ... }:
{
  # Joins the home NetBird (home LAN, its DNS) with the login from
  # `netbird up`: docs/netbird.md.
  flake.modules.nixos.netbird =
    { lib, pkgs, ... }:
    let
      unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      # The client follows the server's NetBird release; the system nixpkgs
      # lags behind, and its module's UI wrapper only fits the older UI.
      disabledModules = [ "services/networking/netbird.nix" ];
      imports = [ "${inputs.nixpkgs-unstable}/nixos/modules/services/networking/netbird.nix" ];

      # With resolvconf the client takes over all DNS and keeps the
      # upstreams it saw at its start, so a VPN's DNS that comes up later is
      # ignored. With resolved it only answers its match domains on wt0:
      # docs/netbird.md (DNS).
      services.resolved.enable = true;

      # The default client: unit and CLI `netbird`, interface wt0, UDP 51820.
      services.netbird = {
        enable = true;
        package = unstable.netbird;
        ui.package = unstable.netbird-ui;
        ui.enable = true;
        # The home LAN is a network route; routing peers set "both".
        useRoutingFeatures = lib.mkDefault "client";

        clients.default = {
          environment.NB_MANAGEMENT_URL = "https://netbird.leidwein.com";
          # Off by default on Linux: restarts the engine when the default
          # route changes (another network), docs/netbird.md.
          config.NetworkMonitor = true;
        };
      };
    };
}

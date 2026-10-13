{ inputs, ... }:
{
  # Joins the home NetBird (home LAN, its DNS) with the login from
  # `netbird-home up`: docs/netbird.md.
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

      services.netbird = {
        package = unstable.netbird;
        ui.package = unstable.netbird-ui;
        ui.enable = true;
        # The home LAN is a network route.
        useRoutingFeatures = "client";

        clients.home = {
          port = 51821;
          environment.NB_MANAGEMENT_URL = "https://netbird.leidwein.com";
          # The hardened client (own user, read-only /etc) only sets DNS
          # through systemd-resolved; these hosts use resolvconf.
          hardened = false;
        };
      };
    };
}

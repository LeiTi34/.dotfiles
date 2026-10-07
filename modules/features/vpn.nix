{ ... }:
{
  # WireGuard is built into NetworkManager; OpenVPN needs the plugin.
  flake.modules.nixos.vpn = { pkgs, ... }: {
    networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  };
}

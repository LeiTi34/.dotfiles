{ ... }:
{
  # Trash, network shares and MTP devices in file managers.
  flake.modules.nixos.gvfs = { pkgs, ... }: {
    services.gvfs = {
      enable = true;
      package = pkgs.gnome.gvfs;
    };
  };
}

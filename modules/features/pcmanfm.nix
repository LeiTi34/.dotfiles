{ config, ... }:
{
  flake.homeModules.pcmanfm = { config, lib, pkgs, ... }:
    let
      conf = "${config.xdg.configHome}/pcmanfm/default/pcmanfm.conf";
    in
    {
      home.packages = [ pkgs.pcmanfm ];

      # pcmanfm rewrites its config at runtime (window size, sort order), so
      # it can't be a read-only link; only the default view is set in place.
      home.activation.pcmanfmListView = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p "$(dirname "${conf}")"
        run ${lib.getExe pkgs.crudini} --ini-options=nospace --set "${conf}" ui view_mode list
      '';
    };

  flake.modules.nixos.pcmanfm = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.pcmanfm
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.wallpaper = { config, lib, pkgs, ... }:
    let
      # Stable path for DMS to remember; the store path changes with every
      # new copy of the flake.
      path = "${config.xdg.dataHome}/backgrounds/wallpaper.jpg";
      session = "${config.xdg.stateHome}/DankMaterialShell/session.json";
      jq = lib.getExe pkgs.jq;
    in
    {
      xdg.dataFile."backgrounds/wallpaper.jpg".source = ./wallpaper.jpg;

      # DMS keeps the wallpaper in its session state, which it rewrites at
      # runtime. Only fill in the default when no wallpaper is set or the set
      # one is gone, so a wallpaper picked in DMS stays.
      home.activation.dmsDefaultWallpaper = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run ${pkgs.writeShellScript "dms-default-wallpaper" ''
          set -eu
          current=""
          [ -f "${session}" ] && current=$(${jq} -r '.wallpaperPath // ""' "${session}")
          if [ -z "$current" ] || [ ! -e "$current" ]; then
            mkdir -p "$(dirname "${session}")"
            if [ -f "${session}" ]; then
              ${jq} --arg wp "${path}" '.wallpaperPath = $wp' "${session}" > "${session}.tmp"
              mv "${session}.tmp" "${session}"
            else
              ${jq} -n --arg wp "${path}" '{ wallpaperPath: $wp }' > "${session}"
            fi
          fi
        ''}
      '';
    };

  flake.modules.nixos.wallpaper =
    let
      uri = "file://${./wallpaper.jpg}";
    in
    {
      # GNOME: locked system-wide, so GNOME can't replace it with a wallpaper
      # in the user's dconf.
      programs.dconf.profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/desktop/background" = {
              picture-uri = uri;
              picture-uri-dark = uri;
              picture-options = "zoom";
            };
            "org/gnome/desktop/screensaver" = {
              picture-uri = uri;
              picture-options = "zoom";
            };
          };
        }
      ];

      home-manager.users.${config.profiles.primaryUser.name}.imports = [
        config.flake.homeModules.wallpaper
      ];
    };
}

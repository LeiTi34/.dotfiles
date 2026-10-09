# { config, pkgs, lib, ... }:
#
# {
#   nixpkgs.overlays = [
#   (self: super: {
#     qtile-unwrapped = super.qtile-unwrapped.overrideAttrs(_: rec {
#       postInstall = let
#         qtileSession = ''
#         [Desktop Entry]
#         Name=Qtile Wayland
#         Comment=Qtile on Wayland
#         Exec=qtile start -b wayland
#         Type=Application
#         '';
#         in
#         ''
#       mkdir -p $out/share/wayland-sessions
#       echo "${qtileSession}" > $out/share/wayland-sessions/qtile.desktop
#       '';
#       passthru.providedSessions = [ "qtile" ];
#     });
#   })
# ];
#
# services.displayManager.sessionPackages = [ pkgs.qtile-unwrapped ];
# }

{ config, pkgs, lib, ... }:

let
  # Create a standalone derivation just for the session file
  qtileWaylandSession = pkgs.writeTextFile {
    name = "qtile-wayland-session";
    destination = "/share/wayland-sessions/qtile.desktop";
    text = ''
      [Desktop Entry]
      Name=Qtile Wayland
      Comment=Qtile on Wayland
      Exec=qtile start -b wayland
      Type=Application
    '';
  };
in
{
  nixpkgs.overlays = [];
  services.displayManager.sessionPackages = [ qtileWaylandSession ];
}

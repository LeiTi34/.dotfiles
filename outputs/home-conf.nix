{ system, nixpkgs-unstable, nurpkgs, home-manager, ... }:

let
  username = "alex";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
    overlays = [ nurpkgs.overlay ];
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };

  imports = [
    ../users/alex/home.nix
  ];

  mkHome =
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [{ inherit imports; }];
    };
in
{
  alex = mkHome;
}

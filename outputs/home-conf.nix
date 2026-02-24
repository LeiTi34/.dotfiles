{ system, nixpkgs-unstable, nurpkgs, home-manager, zen-browser, ... }:

let
  username = "alex";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
    config.xdg.configHome = configHome;
    overlays = [ nurpkgs.overlays.default ];
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };

  extraSpecialArgs = { inherit zen-browser system; };

  imports = [
    ../users/alex/home.nix
  ];

  mkHome =
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = extraSpecialArgs;
      modules = [{ inherit imports; }];
    };
in
{
  alex = mkHome;
}

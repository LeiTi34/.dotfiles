{
  description = "My System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nurpkgs.url = "github:nix-community/NUR";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nurpkgs, home-manager, zen-browser, ... }:
    let
      system = "x86_64-linux";
    in
    rec {
      homeConfiguration = 
       import ./outputs/home-conf.nix {
          inherit system nixpkgs-unstable nurpkgs home-manager zen-browser;
       };

      nixosConfigurations =
        import ./outputs/nix-conf.nix {
          inherit inputs system nixpkgs-unstable;
      };
    };
}

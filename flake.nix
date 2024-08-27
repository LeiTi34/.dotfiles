{
  description = "My System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nurpkgs.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nurpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    rec {
      homeConfiguration = 
       import ./outputs/home-conf.nix {
          inherit system nixpkgs-unstable nurpkgs home-manager;
       };

      nixosConfigurations =
        import ./outputs/nix-conf.nix {
          inherit inputs system;
      };
    };
}

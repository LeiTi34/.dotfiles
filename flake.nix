{
  description = "My System Config";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nurpkgs.url = "github:nix-community/NUR";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./modules/flake-parts.nix
        ./modules/configurations/nixos.nix
        ./modules/users/alex.nix
        ./modules/features/unfree.nix
        ./modules/features/neovim.nix
        ./modules/features/xorg.nix
        ./modules/features/xorg-utils.nix
        ./modules/features/qtile.nix
        ./modules/hosts/PCNX-LeiAle1.nix
        ./modules/hosts/vm.nix
      ];
    };
}

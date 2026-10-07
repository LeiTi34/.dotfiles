{ config, lib, ... }:
let
  version = "1.35.0";
in
{
  # azd (Azure Developer CLI) is not in nixpkgs; this wraps the release binary.
  flake.homeModules.azd =
    { pkgs, ... }:
    let
      azd = pkgs.stdenvNoCC.mkDerivation {
        pname = "azd";
        inherit version;

        src = pkgs.fetchurl {
          url = "https://github.com/Azure/azure-dev/releases/download/azure-dev-cli_${version}/azd-linux-amd64.tar.gz";
          hash = "sha256-lnxY3qaT1CJW+++u5IrC+BLxNFKJmPf6n09ULL9/7aE=";
        };
        sourceRoot = ".";

        nativeBuildInputs = [ pkgs.autoPatchelfHook ];

        installPhase = ''
          runHook preInstall
          install -Dm755 azd-linux-amd64 $out/bin/azd
          runHook postInstall
        '';

        meta = {
          description = "Azure Developer CLI";
          homepage = "https://github.com/Azure/azure-dev";
          license = lib.licenses.mit;
          mainProgram = "azd";
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      home.packages = [ azd ];
    };

  flake.modules.nixos.azd = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.azd
    ];
  };
}

{ config, lib, ... }:
let
  version = "0.1.5";
  hash = "sha256-i6c/FjIqQlRMrTqXSQv9FJV7l7EItY9DkT5soIijzdc=";
in
{
  # OpenCode Browse: agents drive the real browser (helium) through a local relay
  # and the Chrome Web Store extension, so they work in the profile with its logins.
  flake.homeModules.browse =
    { pkgs, ... }:
    let
      # @opencode/browse is only a Node launcher for this native binary, which
      # npm installs as the optional dependency of the matching platform.
      browse = pkgs.stdenv.mkDerivation {
        pname = "browse";
        inherit version;
        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/@opencode/browse-linux-x64/-/browse-linux-x64-${version}.tgz";
          inherit hash;
        };
        sourceRoot = "package";
        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeWrapper
        ];
        installPhase = ''
          runHook preInstall
          install -Dm755 bin/browse $out/bin/browse
          runHook postInstall
        '';
        # The relay would otherwise install newer releases by itself. The relay
        # and MCP processes it spawns inherit the variable.
        postFixup = ''
          wrapProgram $out/bin/browse --set OPENCODE_BROWSER_AUTO_UPDATE off
        '';
        meta = {
          description = "Lets agents use your real browser";
          homepage = "https://opencode.ai/product/browse";
          license = lib.licenses.mit;
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
          mainProgram = "browse";
        };
      };
    in
    {
      home.packages = [ browse ];
    };

  flake.modules.nixos.browse = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.browse
    ];
  };
}

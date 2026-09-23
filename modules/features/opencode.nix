{ config, inputs, lib, ... }:
{
  flake-file.inputs.opencode = {
    url = lib.mkDefault "github:anomalyco/opencode/v2.0.15";
  };

  flake.homeModules.opencode =
    { pkgs, ... }:
    let
      upstream = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system};

      cli = upstream.opencode.overrideAttrs (old: {
        # The channel name decides where the daemon registers. Upstream's nix build
        # says "prod", which parks it in service-prod.json while the desktop app
        # waits on service.json and times out. Released CLIs resolve "latest".
        env = old.env // {
          OPENCODE_CHANNEL = "latest";
        };
        # Bun's ResolveMessage is not an Error instance. Missing optional
        # plugin entrypoints must still fall through to the next candidate.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace packages/plugin/src/host.ts \
            --replace-fail '!(error instanceof Error)' '(typeof error !== "object" || error === null)'
        '';

        # Upstream's postInstall builds shell completions by running `opencode
        # completion`, which v2 has no command for; it takes the word as a
        # directory and fails.
        postInstall = "";
      });

      # Upstream's nix/electron.nix reads the version from packages/desktop/package.json
      # but asserts the checksums of an older release, so its electron fetch fails on
      # a hash mismatch. These are the real v44.4.3 checksums.
      electron =
        (pkgs.callPackage "${pkgs.path}/pkgs/development/tools/electron/binary/generic.nix" { }
          "44.4.3"
          {
            x86_64-linux = "fe880a7e37160cfd4e00193bc4c713ead7a778abfe74860a2d36d86fd0be48a8";
            aarch64-linux = "61f084a5ac0f1835efc12b9db17042d92c8c617b03578f96a888acd4a05a0b10";
            x86_64-darwin = "015b52631d92187b552ff4e047255f596a7af4707e388a5890951f0b2645764e";
            aarch64-darwin = "6b728f5dcfae74f3f936f2bca5b3cd9b9659ffea464f67939f004acb55425a85";
            # fetchzip hashes the unpacked headers, not the release tarball.
            headers = "sha256-QPkX+99kArlQhhbgOZe+Hsk28G5cadkUy0G0cIDtEh8=";
          }
        ).overrideAttrs
          (old: {
            # electron 44 ships no ANGLE libraries, but nixpkgs' generic.nix patchelfs
            # $out/libexec/electron/lib*GL* unconditionally; under __structuredAttrs the
            # unmatched glob expands to nothing and patchelf dies with "missing filename".
            postFixup = lib.replaceStrings [ "$out/libexec/electron/lib*GL*" ] [
              "$out/libexec/electron/lib*GL* 2>/dev/null || true"
            ] old.postFixup;
          });

      # desktop.nix uses its callPackage argument for exactly one thing, electron.nix.
      desktop = (upstream.opencode-desktop.override {
        opencode = cli;
        callPackage = _: _: electron;
      }).overrideAttrs (old: {
        # The app inherits the CLI's env. Its channel name picks the application id,
        # and with it the user data directory, updater and telemetry gates.
        env = old.env // {
          OPENCODE_CHANNEL = "prod";
        };
        # scripts/utils.ts reads the staged CLI as an npm package directory, but
        # nix/desktop.nix stages a bare bin/opencode with no package.json beside it.
        preBuild = (old.preBuild or "") + ''
          cliPackage=$(cd packages/desktop && bun -e 'import { getCurrentCli } from "./scripts/utils.ts"; console.log(getCurrentCli().package.replace("@opencode/", ""))')
          mkdir -p "$TMPDIR/desktop-cli/$cliPackage"
          echo "{\"version\":\"$OPENCODE_VERSION\"}" > "$TMPDIR/desktop-cli/$cliPackage/package.json"
        '';
        # electron-builder runs @electron/rebuild, which shells out to node-gyp
        # for msgpackr-extract; the sandbox has neither python nor network, so
        # the build dies there. Nothing needs rebuilding: node_modules already
        # ships node.napi.glibc.node, and N-API is ABI-stable across Node and
        # Electron, so the packaged app loads the prebuilt binding as-is.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace packages/desktop/electron-builder.config.ts \
            --replace-fail 'const getBase = (appId: string): Configuration => ({' \
                           'const getBase = (appId: string): Configuration => ({ npmRebuild: false,'
        '';
      });
    in
    {
      home.packages = [
        cli
        desktop
      ];

      xdg.configFile."opencode" = {
        source = ../../opencode/.config/opencode;
        recursive = true;
      };
    };

  flake.modules.nixos.opencode = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.opencode
    ];
  };
}

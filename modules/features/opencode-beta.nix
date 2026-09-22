{ config, inputs, lib, ... }:
{
  # opencode v2, built from upstream's own flake. Development moved to the `v2`
  # branch, which replaced `beta` (last merged 2026-09-17), and releases are cut
  # from it as `v2.0.x` tags in this same repo. Track a tag rather than the
  # branch: v2.0.13 bumped packages/desktop to electron 44.4.3 but left
  # nix/electron.nix pinning the 42.10.1 SHA256s, so every rev from there to
  # current `v2` fails the desktop build on a fixed-output hash mismatch. Retry
  # the newest tag once those two agree again.
  #
  # Deliberately not following nixpkgs-unstable: the build uses a fixed-output
  # derivation whose hash (nix/hashes.json) is computed against upstream's
  # pinned nixpkgs, so source and hash must move together.
  flake-file.inputs.opencode-beta = {
    url = lib.mkDefault "github:anomalyco/opencode/v2.0.12";
  };

  # Installs the CLI as `opencode2`, so it coexists with `opencode` v1 from
  # nixpkgs (see users/alex/home.nix), alongside the desktop app.
  flake.homeModules.opencode-beta =
    { pkgs, ... }:
    let
      upstream = inputs.opencode-beta.packages.${pkgs.stdenv.hostPlatform.system};

      cli = upstream.opencode.overrideAttrs (old: {
        # Upstream's nix build sets OPENCODE_CHANNEL=prod, which is the channel
        # name their *desktop* release uses; the released CLI resolves "latest"
        # (packages/script: no channel + a real version => latest). The CLI
        # derives its service registration from that name, so "prod" parks the
        # daemon in service-prod.json on port 13420 while every client that does
        # not read the CLI's own config -- the desktop app above all -- waits on
        # service.json and times out. Build the CLI the way its releases are.
        env = old.env // {
          OPENCODE_CHANNEL = "latest";
        };
        # Bun's ResolveMessage is not an Error instance. Missing optional
        # plugin entrypoints must still fall through to the next candidate.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace packages/plugin/src/host.ts \
            --replace-fail '!(error instanceof Error)' '(typeof error !== "object" || error === null)'
        '';
        # Upstream installs `opencode` plus an `opencode2` symlink, so every
        # one of its files (including the hidden `.opencode-wrapped` payload
        # and the completions) collides with v1 in the home-manager profile.
        # Install under the v2 name only. Renaming after the fact is not an
        # option: makeBinaryWrapper bakes the absolute path of the wrapped
        # binary into the wrapper, so the wrapping has to happen here.
        #
        # libxcb joins upstream's wayland: the bundled opentui clipboard
        # reads images through libopentui.so, which dlopens
        # libwayland-client.so.0 and libxcb.so.1 by soname. Without both the
        # host clipboard reports "unsupported" and pasting a screenshot
        # silently does nothing.
        installPhase = ''
          runHook preInstall

          install -Dm755 dist/cli-*/bin/opencode $out/bin/opencode2

          wrapProgram $out/bin/opencode2 \
            --prefix PATH : ${lib.makeBinPath [ pkgs.ripgrep ]} \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath [
                pkgs.wayland
                pkgs.libxcb
              ]
            }

          runHook postInstall
        '';
        # No completions: upstream's postInstall pipes `opencode completion` into
        # installShellCompletion, but v2 has no such command -- it takes the word
        # as a directory to open and fails. That used to leave the error message
        # itself installed as the completion script, because the hook only checks
        # for a non-empty file; since 2.0.12 the message goes to stderr instead
        # and the empty file fails the build outright.
        postInstall = "";
        # versionCheckHook runs mainProgram --version. nix/desktop.nix also
        # bundles `lib.getExe opencode` as the CLI the app shells out to.
        meta = old.meta // {
          mainProgram = "opencode2";
        };
      });

      # The browser tools are an RPC bridge, not a CLI feature: the server-side
      # plugin always registers the namespace, but the browser itself is an
      # Electron view owned by this app, so without it the tools stay
      # permanently disconnected. Injecting our CLI keeps the app on the same
      # patched binary instead of building a vanilla opencode alongside it.
      desktop = (upstream.opencode-desktop.override { opencode = cli; }).overrideAttrs (old: {
        # nix/desktop.nix inherits the CLI's env, so undo the channel rename for
        # the app itself: the desktop half of a release *is* "prod", and the name
        # picks its application id (ai.opencode.desktop, hence its user data
        # directory) and its updater and telemetry gates.
        env = old.env // {
          OPENCODE_CHANNEL = "prod";
        };
        # packages/desktop/scripts/utils.ts takes the staged CLI as an npm package
        # directory now and reads its package.json to write the app's
        # opencode-cli.version (which spares it spawning the 200 MB binary on
        # first launch), but nix/desktop.nix still stages a bare bin/opencode.
        # Write the manifest beside it, before buildPhase fills in the binary.
        # OPENCODE_VERSION is what that binary reports, which is what the app
        # then hands to the service version check.
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
    };

  flake.modules.nixos.opencode-beta = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.opencode-beta
    ];
  };
}

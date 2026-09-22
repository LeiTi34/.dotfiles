{ config, inputs, lib, ... }:
{
  # opencode v2 beta, built from upstream's own flake on the `beta` branch.
  # Deliberately not following nixpkgs-unstable: the build uses a fixed-output
  # derivation whose hash (nix/hashes.json) is computed against upstream's
  # pinned nixpkgs, so source and hash must move together.
  flake-file.inputs.opencode-beta = {
    url = lib.mkDefault "github:anomalyco/opencode/beta";
  };

  # Installs the binary as `opencode2`, so it coexists with `opencode` v1
  # from nixpkgs (see users/alex/home.nix).
  flake.homeModules.opencode-beta =
    { pkgs, ... }:
    let
      # Upstream's nix packaging does not account for opencode-pty, which
      # packages/cli/script/opencode-pty.ts downloads at build time. The build
      # derivation has no network, so we pre-populate the cache it checks first.
      # Version and hashes are pinned in that same script; bump them together.
      ptyVersion = "0.1.5";
      ptyTarballs = {
        # Statically linked musl artifact. The glibc build is dynamically linked
        # against /lib64/ld-linux-x86-64.so.2 and will not run unpatched on NixOS,
        # so we use the static one and stage it at the glibc path the script wants.
        x86_64-linux = {
          target = "x86_64-unknown-linux-musl";
          expects = "x86_64-unknown-linux-gnu";
          hash = "sha256-KhdjAt49JPiuP7rPC0r857SvPgCr1hmQYYekh7XlC9Y=";
        };
      };
      pty = ptyTarballs.${pkgs.stdenv.hostPlatform.system};
      ptyArchive = pkgs.fetchurl {
        url = "https://github.com/anomalyco/opencode-pty/releases/download/v${ptyVersion}/opencode-pty-${ptyVersion}-${pty.target}.tar.gz";
        inherit (pty) hash;
      };
    in
    {
      home.packages = [
        (inputs.opencode-beta.packages.${pkgs.stdenv.hostPlatform.system}.opencode.overrideAttrs (old: {
          # Bun's ResolveMessage is not an Error instance. Missing optional
          # plugin entrypoints must still fall through to the next candidate.
          postPatch = (old.postPatch or "") + ''
            substituteInPlace packages/plugin/src/host.ts \
              --replace-fail '!(error instanceof Error)' '(typeof error !== "object" || error === null)'
          '';
          preBuild = (old.preBuild or "") + ''
            ptydir=packages/cli/.cache/opencode-pty/${ptyVersion}/${pty.expects}
            mkdir -p "$ptydir"
            tar xzf ${ptyArchive} --strip-components=1 -C "$ptydir" \
              opencode-pty-${ptyVersion}-${pty.target}/opencode-pty
            chmod 755 "$ptydir/opencode-pty"
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
          postInstall = ''
            # trick yargs into also generating zsh completions
            installShellCompletion --cmd opencode2 \
              --bash <($out/bin/opencode2 completion) \
              --zsh <(SHELL=/bin/zsh $out/bin/opencode2 completion)
          '';
          # versionCheckHook runs mainProgram --version.
          meta = old.meta // {
            mainProgram = "opencode2";
          };
        }))
      ];
    };

  flake.modules.nixos.opencode-beta = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.opencode-beta
    ];
  };
}

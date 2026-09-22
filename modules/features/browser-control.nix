{ config, lib, ... }:
let
  # Pinned on purpose, and bumped by hand: the relay and the unpacked extension
  # ship from this one package and must stay in lockstep, and every upgrade needs
  # the extension reloaded in the browser. To bump: set the version, set both
  # hashes to lib.fakeHash, build twice, and paste back what nix reports. Then
  # regenerate the lock file next to this module:
  #   tar xzf <the npm tarball> && jq 'del(.devDependencies, .scripts)' package.json ... &&
  #   npm install --package-lock-only --ignore-scripts
  version = "0.8.2";
  tarballHash = "sha256-eYOFnQlBgwmHjJC1In9Md0wVg+vZqF0RAIv4wf5xt5w=";
  npmDepsHash = "sha256-bvq/iSiBK80Sc5nyMrkx0uyggHacj0gAcrUn6cNWyhs=";
in
{
  # Browser Control drives an existing Chromium-family browser (here: helium)
  # through a local relay and an unpacked extension, so agents work in the real
  # profile with its logins. It is unrelated to opencode's built-in browser.*
  # tools, which are served only by the desktop app's own embedded browser and
  # are turned off in opencode/.config/opencode/opencode.json.
  flake.homeModules.browser-control =
    { pkgs, ... }:
    let
      package = "@opencode-ai/browser-control";

      src = pkgs.runCommand "browser-control-src-${version}" { nativeBuildInputs = [ pkgs.jq ]; } ''
        mkdir -p $out
        tar xzf ${
          pkgs.fetchurl {
            url = "https://registry.npmjs.org/${package}/-/browser-control-${version}.tgz";
            hash = tarballHash;
          }
        } --strip-components=1 -C $out

        # npm ci refuses a package.json its lock does not match. dist/ and
        # extension/dist/ are published prebuilt, so the dev dependencies (esbuild,
        # vitest, typescript) only exist to drag the closure up; drop them here and
        # in the lock beside this module, together.
        jq 'del(.devDependencies, .scripts)' $out/package.json > $out/package.json.stripped
        mv $out/package.json.stripped $out/package.json
        cp ${./browser-control-package-lock.json} $out/package-lock.json
      '';

      browser-control = pkgs.buildNpmPackage {
        pname = "browser-control";
        inherit version src npmDepsHash;
        # dist/cli.js and dist/mcp.js are published as bundles; there is nothing to
        # build, and --ignore-scripts keeps playwright-core from reaching for a
        # browser download it never uses (it talks CDP through the extension).
        dontNpmBuild = true;
        npmFlags = [ "--ignore-scripts" ];
        meta = {
          description = "Local browser driver for trusted agents";
          homepage = "https://github.com/anomalyco/browser-control";
          license = lib.licenses.mit;
          mainProgram = "browser-control";
        };
      };

      installed = "${browser-control}/lib/node_modules/${package}";
    in
    {
      home.packages = [ browser-control ];

      # Chromium records an unpacked extension by path, and a store path changes
      # with every bump. Load this stable symlink instead, so an upgrade only
      # needs the extension reloaded, never picked again.
      home.file.".local/share/browser-control/extension".source = "${installed}/extension/dist";

      # Ship the skill from the same package rather than vendoring a copy, so the
      # workflow text can never describe a different version than the installed
      # binary. opencode/.config/opencode is linked file by file (see
      # features/opencode.nix), so this adds to that tree instead of replacing it.
      xdg.configFile."opencode/skills/browser-control/SKILL.md".source =
        "${installed}/skills/browser-control/SKILL.md";
    };

  flake.modules.nixos.browser-control = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.browser-control
    ];
  };
}

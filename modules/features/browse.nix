{ config, lib, ... }:
let
  # browse-package-lock.json has to be regenerated with every bump.
  version = "0.0.16";
  tarballHash = "sha256-Yt78xDraYiBpsOVKjBsn7L5YZwHSTd/AuRUYAb7RKrg=";
  npmDepsHash = "sha256-kT9umRNAgGmK8z95lrhdvzH+G//4QR3RE/3VBeDqQGE=";
in
{
  # OpenCode Browse: agents drive the real browser (helium) through a local relay
  # and the Chrome Web Store extension, so they work in the profile with its logins.
  flake.homeModules.browse =
    { pkgs, ... }:
    let
      package = "@opencode/browse";

      src = pkgs.runCommand "browse-src-${version}" { nativeBuildInputs = [ pkgs.jq ]; } ''
        mkdir -p $out
        tar xzf ${
          pkgs.fetchurl {
            url = "https://registry.npmjs.org/${package}/-/browse-${version}.tgz";
            hash = tarballHash;
          }
        } --strip-components=1 -C $out

        # npm ci refuses a package.json its lock does not match. dist/ is
        # published bundled, so the dev dependencies only drag the closure up;
        # drop them here and in the lock beside this module, together.
        jq 'del(.devDependencies, .scripts)' $out/package.json > $out/package.json.stripped
        mv $out/package.json.stripped $out/package.json
        cp ${./browse-package-lock.json} $out/package-lock.json
      '';

      browse = pkgs.buildNpmPackage {
        pname = "browse";
        inherit version src npmDepsHash;
        dontNpmBuild = true;
        npmFlags = [ "--ignore-scripts" ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        # The relay would otherwise check npm hourly and `npm install -g` a newer
        # release. The relay and MCP processes it spawns inherit the variable.
        postInstall = ''
          wrapProgram $out/bin/browse --set OPENCODE_BROWSER_AUTO_UPDATE off
        '';
        meta = {
          description = "Lets agents use your real browser";
          homepage = "https://opencode.ai/product/browse";
          license = lib.licenses.mit;
          mainProgram = "browse";
        };
      };
    in
    {
      home.packages = [ browse ];

      # Ship the skill from the same package, so it always matches the binary.
      xdg.configFile."opencode/skills/browse/SKILL.md".source =
        "${browse}/lib/node_modules/${package}/skills/browse/SKILL.md";
    };

  flake.modules.nixos.browse = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.browse
    ];
  };
}

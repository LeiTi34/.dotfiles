{ config, inputs, lib, ... }:
{
  flake-file.inputs.opencode = {
    # No nixpkgs follows: the node_modules hash depends on the bun version.
    url = lib.mkDefault "github:anomalyco/opencode/v2.2.7";
  };

  flake.homeModules.opencode =
    { pkgs, lib, ... }:
    let
      upstream = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system};

      # Upstream's nix/hashes.json lags behind its releases (v2.2.7 still has the
      # hash from 2026-10-31). The hash depends on the bun version, hence on the
      # input's own nixpkgs.
      opencode = upstream.opencode.override {
        node_modules = upstream.opencode.node_modules.override {
          hash = "sha256-1mAAHaGwJ1sqxRe0YUsPEXJpXzEsZVX0VOmxRbY75n4=";
        };
      };

      # Anthropic gates model access on the Claude Code version the Anthropic auth
      # plugin reports, and that gate moves on Anthropic's schedule rather than the
      # plugin's release schedule: claude-opus-5-5 rejects anything below 2.1.280,
      # while older plugin releases (still in OpenCode's npm cache) report 2.1.258.
      claudeCodeVersion = "2.1.280";

      # The variable is read once when the plugin loads, so it has to be on the
      # process rather than in the shell profile the desktop app never sources.
      # --set-default leaves it overridable per invocation. A binary wrapper,
      # because the desktop build rejects a CLI that isn't a native executable.
      wrapClaudeCodeVersion = binary: old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeBinaryWrapper ];
        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/${binary} \
            --set-default ANTHROPIC_CLAUDE_CODE_VERSION ${claudeCodeVersion}
        '';
      };

      cli = opencode.overrideAttrs (old: {
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
        # Only `opencode`: drop upstream's opencode2 alias and its completions.
        postInstall = old.postInstall + ''
          rm $out/bin/opencode2 \
            $out/share/bash-completion/completions/opencode2.bash \
            $out/share/fish/vendor_completions.d/opencode2.fish \
            $out/share/zsh/site-functions/_opencode2
        '';
      }
      // wrapClaudeCodeVersion "opencode" old);

      desktop = (upstream.opencode-desktop.override { opencode = cli; }).overrideAttrs (old: {
        # The app inherits the CLI's env. Its channel name picks the application id,
        # and with it the user data directory, updater and telemetry gates.
        env = old.env // {
          OPENCODE_CHANNEL = "prod";
        };
        # nix/desktop.nix stages the CLI in $OPENCODE_CLI_DIST, but the desktop's
        # script/build.ts only looks in packages/cli/dist.
        buildPhase =
          assert lib.hasInfix "bun run build\n" old.buildPhase;
          lib.replaceStrings [ "bun run build\n" ] [ ''
            ln -s "$OPENCODE_CLI_DIST" ../cli/dist
            bun run build
          '' ] old.buildPhase;
      }
      // wrapClaudeCodeVersion "opencode-desktop" old);
    in
    {
      home.packages = [
        cli
        desktop
      ];

      xdg.configFile."opencode" = {
        source = ../../configs/opencode/.config/opencode;
        recursive = true;
      };

      # Not in configs/opencode: the Arch machine stows that folder too.
      xdg.configFile."opencode/AGENTS.md".text = ''
        # Environment

        - The system runs NixOS. Programs that aren't installed can be run
          without installing them: `nix run nixpkgs#<program> -- <args>`.

        # Subagents and parallel work

        Delegate by default. Keep the main session's context for decisions, edits
        and talking to the user; reading, searching and researching go to subagents.

        - Investigation that takes more than two or three reads, greps or shell
          lookups goes to an `explore` subagent: where something is defined, how a
          code path works, what an API, config, log or diff contains. Ask it for
          the answer (files, lines, a short summary), not raw output.
        - Research and multi-step work that isn't plain reading goes to `general`:
          reading upstream source or docs, comparing versions, trying commands in
          /tmp/opencode, drafting an isolated change.
        - Split the task before starting. Independent parts (several issues,
          repos, components, questions) each get their own subagent, launched in
          one message so they run in parallel. Use `background` for results you
          don't need right away, and keep working in the meantime.
        - In Plan mode, explore with subagents first and plan from their results.
          There, subagents only read and research; they don't modify files.
        - A subagent sees nothing of this session: give it the goal, absolute
          paths, what is already known, constraints and the shape of the answer.
        - Batch independent tool calls into one message instead of one per turn.
        - Work directly only when the answer is one or two tool calls away or the
          step depends on the previous result.
      '';
    };

  flake.modules.nixos.opencode = {
    imports = [ config.flake.modules.nixos.claude-code ];

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.opencode
    ];
  };
}

{ config, ... }:
{
  flake.homeModules.shell = { pkgs, ... }: {
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          line_break.disabled = true;
          character.success_symbol = "[➜](bold green)";
        };
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      pay-respects.enable = true;

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        options = [ "--cmd cd" ];
      };

      zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autocd = true;
        #defaultKeymap = "vicmd";
        initContent = ''
          eval "$(starship init zsh)"

          if [ -n "''${commands[fzf-share]}" ]; then
            source "$(fzf-share)/key-bindings.zsh"
            source "$(fzf-share)/completion.zsh"
          fi

          portfw() {
            if (( $# < 2 )); then
              echo "Usage: portfw <host> <port1> [port2 ... portN]" >&2
              return 1
            fi

            local host="$1"
            shift

            local -a args=()
            local port
            for port in "$@"; do
              args+=("-L" "''${port}:localhost:''${port}")
            done

            ssh "$host" "''${args[@]}"
          }

          rh() {
            if (( $# < 1 )); then
              echo "Usage: rh <host>" >&2
              return 1
            fi

            ssh -X "$1" -t 'herdr; exec $SHELL'
          }
        '';
      };
    };

    home.packages = with pkgs; [
      starship
      nushell
      fd
      ripgrep
      fastfetch
      pwgen
      fzf
      xclip
      nix-index
    ];
  };

  flake.modules.nixos.shell = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.shell
    ];
  };
}

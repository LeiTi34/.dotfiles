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
    ];
  };

  flake.modules.nixos.shell = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.shell
    ];
  };
}

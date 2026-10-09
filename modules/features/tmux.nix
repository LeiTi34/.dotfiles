{ config, ... }:
{
  flake.homeModules.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        continuum
      ];
      extraConfig = ''
        set -ga terminal-overrides ",*256col*:Tc"
        set -ag terminal-features ",*:clipboard"
        set -g set-clipboard on
        set -g allow-passthrough on

        set -g @continuum-restore 'on'
      '';
    };
  };

  flake.modules.nixos.tmux = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.tmux
    ];
  };
}

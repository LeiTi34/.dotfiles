{ config, ... }:
{
  # Node versions downloaded by fnm are dynamically linked; they run through
  # nix-ld (see the base module).
  flake.homeModules.fnm = { pkgs, ... }: {
    home.packages = [ pkgs.fnm ];

    programs.zsh.initContent = ''
      eval "$(fnm env --use-on-cd --shell zsh --corepack-enabled --resolve-engines)"
    '';
  };

  flake.modules.nixos.fnm = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.fnm
    ];
  };
}

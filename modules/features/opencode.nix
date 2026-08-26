{ config, ... }:
{
  # opencode v1 from nixpkgs, plus the shared config and skills. The source is the
  # same stow package (opencode/.config/opencode) used on non-nix machines.
  flake.homeModules.opencode = { pkgs, ... }: {
    home.packages = [ pkgs.opencode ];

    # recursive = true is load-bearing: it links opencode.json and skills/*/SKILL.md
    # individually and leaves ~/.config/opencode a real, writable directory, so
    # opencode keeps managing node_modules/, package.json, bun.lock, plugins/,
    # cli.json and service-prod.json itself. A non-recursive source would replace the
    # whole directory with a read-only store symlink and break plugin installs.
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

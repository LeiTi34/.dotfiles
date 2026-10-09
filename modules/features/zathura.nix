{ config, ... }:
{
  flake.homeModules.zathura = {
    programs.zathura = {
      enable = true;
      # selected text goes to the clipboard, not the primary selection
      options.selection-clipboard = "clipboard";
    };
  };

  flake.modules.nixos.zathura = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.zathura
    ];
  };
}

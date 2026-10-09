{ config, ... }:
{
  configurations.nixos.TR.module = {
    home-manager.users.${config.profiles.primaryUser.name}.xdg.configFile."hypr/monitors.lua".source =
      ./monitors.lua;
  };
}

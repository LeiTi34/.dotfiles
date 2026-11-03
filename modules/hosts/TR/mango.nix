{ config, ... }:
{
  configurations.nixos.TR.module = {
    home-manager.users.${config.profiles.primaryUser.name}.xdg.configFile."mango/monitors.conf".source =
      ./monitors.conf;
  };
}

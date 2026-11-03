{ config, ... }:
{
  configurations.nixos.PCNX-LeiAle1.module = {
    home-manager.users.${config.profiles.primaryUser.name}.xdg.configFile."mango/monitors.conf".source =
      ./monitors.conf;
  };
}

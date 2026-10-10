{ config, ... }:
let
  user = config.profiles.primaryUser.name;
in
{
  # Connects to Pangolin at boot as the primary user's device, with the login
  # from `pangolin login`: docs/pangolin.md.
  flake.modules.nixos.pangolin-client = { config, pkgs, ... }: {
    environment.systemPackages = [ pkgs.pangolin-cli ];

    systemd.services.pangolin-client = {
      description = "Pangolin client";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists =
        "${config.users.users.${user}.home}/.config/pangolin/accounts.json";
      # The CLI reads the account of $SUDO_USER, as with `sudo pangolin up`.
      environment.SUDO_USER = user;
      # The DNS override goes through resolvconf when it manages
      # /etc/resolv.conf.
      path = [ config.networking.resolvconf.package ];
      serviceConfig = {
        ExecStart = "${pkgs.pangolin-cli}/bin/pangolin up client --attach";
        Restart = "always";
        RestartSec = 5;
        UMask = "0077";
        PrivateTmp = true;
      };
    };
  };
}

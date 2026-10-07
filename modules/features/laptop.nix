{ ... }:
{
  flake.modules.nixos.laptop = { config, ... }:
    let
      # Lid close falls back to plain suspend until the host configures a
      # resume device for hibernation.
      lidAction =
        if config.boot.resumeDevice != "" then "suspend-then-hibernate" else "suspend";
    in
    {
      services = {
        power-profiles-daemon.enable = true;
        upower.enable = true;

        logind.settings.Login = {
          HandleLidSwitch = lidAction;
          HandleLidSwitchExternalPower = lidAction;
          HandleLidSwitchDocked = "ignore";
        };
      };

      systemd.sleep.settings.Sleep = {
        AllowSuspendThenHibernate = "yes";
        HibernateDelaySec = "60min";
      };

      hardware.wirelessRegulatoryDatabase = true;
    };
}

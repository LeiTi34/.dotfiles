{ ... }:
{
  flake.modules.nixos.laptop = { config, ... }:
    let
      # Lid close falls back to plain suspend until the host configures a
      # resume device for hibernation.
      canHibernate = config.boot.resumeDevice != "";
      lidAction = if canHibernate then "suspend-then-hibernate" else "suspend";
    in
    {
      services = {
        power-profiles-daemon.enable = true;
        upower = {
          enable = true;
          percentageAction = 2;
          # The default HybridSleep stays suspended after writing the image
          # and drains the rest of the battery.
          criticalPowerAction = if canHibernate then "Hibernate" else "PowerOff";
        };

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

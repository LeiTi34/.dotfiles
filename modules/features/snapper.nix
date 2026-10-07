{ ... }:
{
  flake.modules.nixos.snapper = {
    services.snapper.configs.home = {
      SUBVOLUME = "/home";
      FSTYPE = "btrfs";
      SPACE_LIMIT = "0.5";
      FREE_LIMIT = "0.2";

      NUMBER_CLEANUP = true;
      NUMBER_MIN_AGE = 1800;
      NUMBER_LIMIT = 50;
      NUMBER_LIMIT_IMPORTANT = 10;

      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_MIN_AGE = 1800;
      TIMELINE_LIMIT_HOURLY = 10;
      TIMELINE_LIMIT_DAILY = 14;
      TIMELINE_LIMIT_WEEKLY = 0;
      TIMELINE_LIMIT_MONTHLY = 6;
      TIMELINE_LIMIT_YEARLY = 0;

      EMPTY_PRE_POST_CLEANUP = true;
      EMPTY_PRE_POST_MIN_AGE = 1800;
    };
  };
}

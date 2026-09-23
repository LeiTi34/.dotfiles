{ ... }:
{
  flake.modules.nixos.btrfs-maintenance =
    { pkgs, ... }:
    {
      services.btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
      };

      systemd.services.btrfs-balance = {
        description = "Light btrfs balance of nearly-empty data chunks";
        serviceConfig = {
          Type = "oneshot";
          # NVMe runs the none I/O scheduler, which ignores I/O priorities, so
          # Nice is the only knob that does anything here.
          Nice = 19;
          # -dusage is what keeps this cheap: a chunk at 5% usage rewrites ~50 MiB
          # to free a whole gigabyte, at 15% it rewrites ~150 MiB, and when nothing
          # matches the balance exits without writing. Higher values would rewrite
          # most of the disk for little gain.
          ExecStart = [
            "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=5 /"
            "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=15 /"
          ];
        };
      };

      systemd.timers.btrfs-balance = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "monthly";
          Persistent = true;
          # autoScrub is monthly as well; keep the two off each other.
          RandomizedDelaySec = "2h";
        };
      };
    };
}

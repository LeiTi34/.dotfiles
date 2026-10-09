{ ... }:
{
  configurations.nixos."PCNX-LeiAle1".module =
    { config, pkgs, ... }:
    {
      networking.hostName = "PCNX-LeiAle1";

      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # NVIDIA GPU
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          modesetting.enable = true;
          open = false;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          nvidiaSettings = true;
        };
        nvidia-container-toolkit.enable = true;
      };

      environment.systemPackages = with pkgs; [
        vulkan-tools
        cifs-utils
      ];

      fileSystems."/mnt/share" = {
        device = "//BAB.network/fileshares";
        fsType = "cifs";
        options = [
          # automount on access; the timeouts keep it from hanging when the
          # share is unreachable
          "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-secrets"
        ];
      };

      networking.firewall.allowedTCPPorts = [
        3000
        3001
        3009
        5432
        8000
        8080
        11434
      ];

      # Release of the first install; don't change it.
      system.stateVersion = "23.05";
    };
}

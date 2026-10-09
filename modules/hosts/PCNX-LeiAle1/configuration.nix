{ ... }:
{
  configurations.nixos."PCNX-LeiAle1".module =
    { config, pkgs, ... }:
    {
      # NVIDIA GPU
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware = {
          nvidia = {
              # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
              package = config.boot.kernelPackages.nvidiaPackages.stable;
              modesetting.enable = true;
              open = false;
              powerManagement.enable = false;
              powerManagement.finegrained = false;
              nvidiaSettings = true;
          };
          nvidia-container-toolkit.enable = true;
      };

      # Use the systemd-boot EFI boot loader.
      boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
      };

      networking.hostName = "PCNX-LeiAle1";

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # xdg.portal = {
      #   enable = true;
      #   # wlr.enable = true;
      #   # gtk portal needed to make gtk apps happy
      #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # };

      # Configure keymap in X11
      # services.xserver.xkbOptions = "eurosign:e,caps:escape";

      # security.pam.services.login.enableGnomeKeyring = true;

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;
      programs.xwayland.enable = true;

      users.users.alex.packages = with pkgs; [
        firefox
        librewolf
        neovim
        # python312Packages.qtile
      ];

      # Docker: CDI for the NVIDIA container toolkit
      virtualisation.docker = {
        daemon.settings.features.cdi = true;
        # rootless = {
        #   enable = true;
        #   setSocketVariable = true;
        # };
      };

      # # Libvirt
      # virtualisation.libvirtd = {
      #   enable = true;
      #
      #   onShutdown = "suspend";
      #   onBoot = "ignore";
      #
      #   qemu = {
      #     package = pkgs.qemu_kvm;
      #
      #     swtpm.enable = true;
      #
      #     ovmf.enable = true;
      #     ovmf.packages = [ pkgs.OVMFFull.fd ];
      #   };
      # };

      services = {
          avahi = {
            enable = true;
            nssmdns4 = true;  # Enable multicast DNS NSS lookup
            openFirewall = true;
            publish = {
              enable = true;
              addresses = true;
              domain = true;
              workstation = true;
            };
          };
          gvfs = {
            enable = true;
            package = pkgs.gnome.gvfs;
          };
          samba = {
            enable = true;
            openFirewall = true;
          };
          dbus.packages = with pkgs; [
            gnome.gvfs
          ];
          gnome.core-apps.enable = true;

          # Cockpit
          cockpit = {
            enable = true;
            openFirewall = true;
            port = 9090;
          };
      };

      # For mount.cifs, required unless domain name resolution is not needed.
      fileSystems."/mnt/share" = {
        device = "//BAB.network/fileshares";
        fsType = "cifs";
        options = let
    # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

        in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        starship
        # python312Packages.qtile

        # virt-manager
        # quickemu
        cifs-utils

        vulkan-tools

        gvfs
        samba
        # Add these specific GVFS packages
        gnome.gvfs
        gnome-online-accounts
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
      # services.postgresql = {
      #   enable = true;
      #   enableTCPIP = true;
      # };
      networking = {
        firewall = {
          allowedTCPPorts = [
            5432
            8080
            8000
            3000
            3009
            3001
            11434
          ];
        };

        # # Add route or VPN
        # interfaces."enp21s0f1".ipv4.routes = [{
        #     address = "10.242.2.0";
        #     prefixLength = 24;
        #     via = "10.242.2.1";
        #  }];
      };

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It's perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.05"; # Did you read the comment?

    };
}

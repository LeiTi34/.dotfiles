{ ... }:
{
  # The account. /home on LTNX-LeiAle1 is owned by 1000:1000 (group alex, not
  # `users`).
  flake.modules.nixos.alex = {
    users.groups.alex.gid = 1000;
    users.users.alex = {
      isNormalUser = true;
      uid = 1000;
      group = "alex";
      extraGroups = [
        "wheel"
        "input"
        "power"
        "video"
        "optical"
        "network"
        "storage"
        "kvm"
        "audio"
      ];
    };
  };

  profiles.primaryUser = {
    name = "alex";
    homeDirectory = "/home/alex";
    # Home Manager config shared by all hosts; programs are features
    # (flake.homeModules.<name>).
    homeModule =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        home = {
          # Release the Home Manager config was written for; don't change it.
          stateVersion = "25.05";

          packages = [ pkgs.fortune ];

          sessionVariables = {
            XDG_CACHE_HOME = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME = "$HOME/.local/share";
            XDG_STATE_HOME = "$HOME/.local/state";
            MOZ_ENABLE_WAYLAND = "1";
          };
        };

        systemd.user.startServices = "sd-switch";

        programs.home-manager.enable = true;
      };
  };
}

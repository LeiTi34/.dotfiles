{ config, ... }:
{
  flake.homeModules.git = { pkgs, ... }: {
    home.packages = with pkgs; [
      git-lfs
      git-crypt
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          email = "a@b.c";
          name = "Alex Leidwein";
        };
        credential = {
          credentialStore = "secretservice";
          helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        };
      };
    };
  };

  flake.modules.nixos.git = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.git
    ];
  };
}

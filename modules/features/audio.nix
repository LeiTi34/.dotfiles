{ config, ... }:
{
  flake.homeModules.audio = { pkgs, ... }: {
    home.packages = with pkgs; [
      pulsemixer
      pavucontrol
    ];
  };

  flake.modules.nixos.audio = {
    services.pulseaudio.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.audio
    ];
  };
}

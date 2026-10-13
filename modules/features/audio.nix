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

      # The Corsair Slipstream receiver is a full-speed USB device. With its
      # 24-bit altsettings, playback and capture together exceed the
      # bandwidth the xHCI grants behind a hub, so the mic fails to start
      # ("Not enough bandwidth for altsetting 2", usb_set_interface -28).
      wireplumber.extraConfig."51-corsair-slipstream" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "node.name" = "~alsa_.*Corsair_CORSAIR_Slipstream.*"; } ];
            actions.update-props."audio.format" = "S16LE";
          }
        ];
      };
    };

    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.audio
    ];
  };
}

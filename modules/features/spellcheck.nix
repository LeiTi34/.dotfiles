{ config, ... }:
{
  # The LibreOffice wrapper picks dictionaries up from every Nix profile.
  flake.homeModules.spellcheck = { pkgs, ... }: {
    home.packages = with pkgs; [
      hunspellDicts.de_AT
      hunspellDicts.en_GB-ise
      hunspellDicts.en_US
      hyphenDicts.de_AT
      hyphenDicts.en_US
    ];
  };

  flake.modules.nixos.spellcheck = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.spellcheck
    ];
  };
}

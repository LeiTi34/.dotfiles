{ config, inputs, lib, ... }:
{
  flake-file.inputs.smartbulb = {
    url = lib.mkDefault "git+ssh://git@git.agrarforschung.at/andreas.mattes/smart-bulb.git";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.homeModules.smart-bulb = {
    imports = [ inputs.smartbulb.homeManagerModules.default ];
    services.smartbulb-bridge = {
      enable = true;
      serverUrl = "https://smartbulb.agrarforschung.at";
    };
  };

  flake.modules.nixos.smart-bulb = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.smart-bulb
    ];
  };
}

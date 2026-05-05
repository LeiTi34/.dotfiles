{ config, inputs, lib, ... }:
{
  flake-file.inputs.smartbulb = {
    url = lib.mkDefault "git+file:///home/alex/projects/smart-bulb";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  flake.homeModules.smart-bulb = {
    imports = [ inputs.smartbulb.homeManagerModules.default ];
    services.smartbulb-bridge = {
      enable = true;
      serverUrl = "http://192.168.67.153:8000";
    };
  };

  flake.modules.nixos.smart-bulb = {
    home-manager.users.${config.profiles.primaryUser.name}.imports = [
      config.flake.homeModules.smart-bulb
    ];
  };
}

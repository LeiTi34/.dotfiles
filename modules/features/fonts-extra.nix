{ lib, ... }:
{
  flake.modules.nixos.fonts-extra =
    { pkgs, ... }:
    let
      # Not in nixpkgs; the font files ship in the npm package.
      phosphor-icons = pkgs.stdenvNoCC.mkDerivation {
        pname = "phosphor-icons";
        version = "2.1.2";

        src = pkgs.fetchzip {
          url = "https://registry.npmjs.org/@phosphor-icons/web/-/web-2.1.2.tgz";
          hash = "sha256-iaNtM6lLYY3Shtbk712DWqayGIi/iofoASCysZqm3Kc=";
        };

        installPhase = ''
          runHook preInstall
          install -Dm644 -t $out/share/fonts/truetype src/*/*.ttf
          runHook postInstall
        '';

        meta = {
          description = "Phosphor icon font";
          homepage = "https://phosphoricons.com";
          license = lib.licenses.mit;
        };
      };
    in
    {
      fonts.packages = with pkgs; [
        # Liberation 2.x is derived from Arimo/Tinos/Cousine (croscore),
        # so it covers the metric-compatible Arial/Times/Courier set.
        liberation_ttf
        caladea
        carlito
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        fira-code
        roboto-mono
        nerd-fonts.symbols-only

        font-awesome
        material-design-icons
        phosphor-icons

        source-sans
        source-sans-pro
        poppins
        league-gothic
      ];
    };
}

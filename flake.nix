{
  description = "thulis' NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;
  in {
    iosevka-comfy = pkgs.stdenvNoCC.mkDerivation {
      name = "iosevka-comfy";
      dontConfigue = true;
      src = pkgs.fetchzip {
        url = "https://github.com/protesilaos/iosevka-comfy/archive/refs/tags/1.1.0.zip";
        stripRoot = false;
        sha256 = "sha256-JOTQQDC0i5oOzILegslg7voXDWybeM6Vh/AEVDZeXQ4=";
      };
      installPhase = ''
        mkdir -p $out/share/fonts
        cp -R $src/iosevka-comfy-1.1.0/ $out/share/fonts/truetype/
      '';
      meta = { description = "The Iosevka Comfy Font Family derivation."; };
    };

    homeManagerConfigurations = {
      mnn = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./common-home.nix
          ./workstation/home.nix
        ];
      };

      thulis = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # custom config
          ./common-home.nix
          ./thinkpad/home.nix

          # hyperland window manager
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
        ];
      };
    };

    nixosConfigurations = {
      workstation = lib.nixosSystem {
        inherit system;
        modules = [
          ./workstation/configuration.nix
          ./workstation/hardware-configuration.nix
        ];
      };

      thinkpad = lib.nixosSystem {
        inherit system;
        modules = [
          ./thinkpad/configuration.nix
          ./thinkpad/hardware-configuration.nix
        ];
      };
    };
  };
}

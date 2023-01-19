{
  description = "thulis' NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
          ./common-home.nix
          ./thinkpad/home.nix
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
        ];
      };
    };
  };
}

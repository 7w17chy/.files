{
  description = "thulis' NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    # make home-manager use our version of nixpkgs
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home.nix
          {
            home = {
              username = "mnn";
              homeDirectory = "/home/mnn";
              stateVersion = "22.11";
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      workstation = lib.nixosSystem {
        inherit system;
        modules = [
          ./workstation/configuration.nix
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

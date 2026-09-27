{
  description = "Devon's NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      nixpkgs-lib = nixpkgs-unstable.lib;
      home-manager-lib = home-manager.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations."nixos" = nixpkgs-lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
        ];
      };

      homeConfigurations."devon" = home-manager-lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];
      };
    };
}

{
  description = "Devon's NixOS flake configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
  };

  outputs = { self, nixpkgs, home-manager, nixos-grub-themes, ... }: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      grubThemes = nixos-grub-themes;
    in {
      nixosConfigurations = {
        winterfell = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit grubThemes; };
          modules = [ ./configuration.nix ];
        };
      };
      homeConfigurations = {
        devon = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}

{
  description = "My working nixos dev/personal configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./modules/hyprland.nix
        ./modules/dev.nix
        ./modules/packages.nix
      ];
    };
  };
}

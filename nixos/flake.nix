{
  description = "jakes nixos configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      main = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/configuration.nix
          ./modules/core.nix
          ./modules/desktop.nix
	  ./modules/dev.nix
	  ./modules/programs.nix
        ];
      };
    };
  };
}

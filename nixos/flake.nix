{
  description = "jakes nixos configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/default.nix
          ./modules/core.nix
          ./modules/desktop.nix
	  ./modules/dev.nix
	  ./modules/programs.nix
        ];
      };
    };
  };
}

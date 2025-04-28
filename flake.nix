# ~/dotfiles/flake.nix
{
  description = "Nixos config with home-manager (round 2) lol";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # Get nixpkgs specific to the system
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # Define your Home Manager configuration here
      homeConfigurations = {
	# WSL
        "shoe@shoe" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs; # Use the nixpkgs we defined above
          # The list of modules defining your configuration
          modules = [
            ./home-manager/home.nix
            # We'll add more modules here later (like for git, zsh, nvim)
          ];
          # Example if i need to pass extra args down to my files
          # extraSpecialArgs = { inherit inputs; };
        };

        # Configurations for other machines (mac, other linux) will go here later
        # "your_mac_username@your_mac_hostname" = home-manager.lib.homeManagerConfiguration { ... };
      };
    };
} 

# ~/dotfiles/flake.nix
{
  description = "Home Manager configurations for all my machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Helper: build pkgs for a given system
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Helper: build a homeManagerConfiguration
      mkHome = { system, username, homeDirectory ? "/home/${username}", extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          modules = [
            ./home-manager/home.nix
            { home.username = username; home.homeDirectory = homeDirectory; }
          ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        # WSL on x86_64 Linux
        "shoe@shoe" = mkHome {
          system   = "x86_64-linux";
          username = "shoe";
        };

        # --- Add new machines below ---
        # macOS (Apple Silicon) example:
        # "jake@Jakes-MacBook-Pro" = mkHome {
        #   system        = "aarch64-darwin";
        #   username      = "jake";
        #   homeDirectory = "/Users/jake";
        # };

        # macOS (Intel) example:
        # "jake@work-mbp" = mkHome {
        #   system        = "x86_64-darwin";
        #   username      = "jake";
        #   homeDirectory = "/Users/jake";
        # };

        # Linux laptop/desktop example:
        # "jake@thinkpad" = mkHome {
        #   system   = "x86_64-linux";
        #   username = "jake";
        # };
      };
    };
}

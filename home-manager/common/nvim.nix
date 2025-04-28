{ pkgs, ... }:

{
  # Make sure home-manager installs nvim
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
    ];
    
    viAlias = true;
    vimAlias = true;
  };

  home.file.".config/nvim" = {
    source = ../../config/nvim; # Points to our nvim config
    recursive = true; 		# Tells home-manager to link the dir recursively
  };

  home.packages = with pkgs; [
    ripgrep
    fd
  ];  
}


{ config, pkgs, ... }:

{
  # Development packages
  environment.systemPackages = with pkgs; [
    cmake 
    curl
    direnv
    fd 
    fzf
    git
    gcc
    htop
    jq
    lazygit
    neofetch
    neovim 
    ripgrep
    starship
    stow
    tmux
    tree
    wget
    zsh
  ];

  # Shell configuration
  programs.zsh.enable = true;
  programs.starship.enable = true;

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    config = {
      user.name = "jakeshoemaker";
      user.email = "jakeshoe3@gmail.com";
      init.defaultBranch = "main";
    };
  };
}

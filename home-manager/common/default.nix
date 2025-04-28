# ~/dotfiles/home-manager/common/default.nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git         
    eza         # modern ls 
    jq          
    ripgrep     
    fzf         # Fuzzy finder
    bat         # Cat clone with syntax highlighting
    fd          # Find alternative
    curl        
    wget        
    htop        
    tmux        
    direnv      # Directory-based environment switcher
    unzip       #
    tree        # Display directory trees

    # Core utils - often good to ensure consistent versions
    coreutils   # GNU core utilities (ls, cp, mv, etc.)
    gnugrep     # GNU grep
    gnused      # GNU sed
    gnutar      # GNU tar
    gzip        # Compression utility
    which       # Locate command

    # --- Global Language Tooling ---
    lua-language-server 
    nixpkgs-fmt          
    nil         # nix ls
    marksman    # markdown ls
  ];
}

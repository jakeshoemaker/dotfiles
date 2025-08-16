# ~/dotfiles/home-manager/common/default.nix
{ pkgs, ... }:

{

  # --- SSH ---
  programs.ssh = {
    enable = true;
    startAgent = true;                        # start ssh-agent on login
    addKeysToAgent = [ "~/.ssh/id_ed25519" ]; # auto add ssh key to ssh-agent

    matchBlocks = {                           # define host ssh configuration
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };

  };
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
    unzip       
    tree        # Display directory trees
    just        # Task runner

    # --- Core linux utils ---
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
    go          # Go programming language
    bun
  ];
}

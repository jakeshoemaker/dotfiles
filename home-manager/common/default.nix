# ~/dotfiles/home-manager/common/default.nix
{ pkgs, ... }:
let
  geminiCli = pkgs.buildNpmPackage {
    pname = "gemini-cli";
    version = "0.3.0-nightly.20250823.1a89d185";

    src = pkgs.fetchFromGitHub {
      owner = "google-gemini";
      repo = "gemini-cli";
      rev = "v0.3.0-nightly.20250823.1a89d185";
      sha256 = "sha256-qGIwqKmV5Y1KWzV12kkfEIz8O+//Vs+nLEvMqkpdWtM=";
    };

    nodejs = pkgs.nodejs_20;
    npmDepsHash = "sha256-lRygITKPUACUUxT+PhZ4eWAqK/myR9320GDF+85z21U=";
  };
in
{

  # --- SSH ---
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    
    matchBlocks = {
      "*" = {
        identityFile = ["~/.ssh/id_ed25519"];
      };

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
    yaml-language-server
    nixpkgs-fmt          
    nixd        # nix ls based on libraries
    nil         # nix ls
    marksman    # markdown ls
    go          # Go programming language
    bun         # Bun package manager
    nodejs_20   # Node.js runtime
    lazygit     # Git TUI
    lazydocker  # Docker TUI
    uv          # Python package manager

    # --- Container Tooling ---
    docker          # Docker CLI (Container runtime)
    docker-compose  # Docker Compose (Lightweight container orchestration)
    kubernetes      # Kubernetes nixpkg [ installs kubeadm, kubectl, and more ]
    kubernetes-helm # Kubernetes package manager
    k0sctl          # Kubernetes bootstrappiung / management tool for k0s clusters
    kind            # Kubernetes in Docker
    k9s             # Kubernetes Cluster Management (TUI)
    tilt            # Kubernetes development tool
    
    geminiCli       # defined locally, gemini-cli npm package
  ];
}

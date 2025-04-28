# ~/dotfiles/home-manager/common/shell.nix
{ pkgs, config, ... }:

{
  # enable zsh configuration via home-manager
  programs.zsh = {
    enable = true;
    
    # define aliases
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";             # Long format, all files (hidden)
      l = "eza -lbhF --git";      # Detailed view: long, blocks, header, classify, git status
      lt = "eza --tree --level=2"; # Tree view, 2 levels deep

      # bat alias (use bat instead of cat for viewing files)
      cat = "bat --paging=never"; # Use bat, disable paging for pipe compatibility if needed
                                  # Or just 'bat' if you always want its pager

      # Other useful aliases
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";

    };

    # These settings require installing the packages listed in home.packages below
    autosuggestion.enable = true;     # Suggest commands as you type (from history)
    syntaxHighlighting.enable = true; # Highlight commands and syntax in the terminal
    enableCompletion = true;          # Enable Zsh's built-in completion system
    initContent = ''
      # Initialize starship prompt
      eval "$(starship init zsh)"

      # Initialize direnv hook
      eval "$(direnv hook zsh)"
    '';


    # Set history options
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history"; # Store history in XDG compliant location
    };
  };

  # Ensure Zsh itself & packages for enabled plugins are installed
  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    starship
    direnv
  ];
}

# ~/dotfiles/home-manager/common/shell.nix
{ pkgs, config, ... }:

{
  # direnv — shell hook is injected automatically when both programs are enabled
  programs.direnv = {
    enable            = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;  # Faster nix-shell / flake integration
  };

  # Starship prompt — configured here so the same prompt appears everywhere
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      directory = {
        truncation_length = 3;
        truncate_to_repo  = true;
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        style  = "bold purple";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style  = "bold red";
      };
      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = "❄️ ";
        style  = "bold blue";
      };
      cmd_duration = {
        format         = "[$duration]($style) ";
        style          = "yellow";
        min_time       = 2000;
        show_milliseconds = false;
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
    };
  };

  # enable zsh configuration via home-manager
  programs.zsh = {
    enable = true;

    # define aliases
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la"; # Long format, all files (hidden)
      l = "eza -lbhF --git"; # Detailed view: long, blocks, header, classify, git status
      lt = "eza --tree --level=2"; # Tree view, 2 levels deep

      # bat alias (use bat instead of cat for viewing files)
      cat = "bat --paging=never";
      # Use bat, disable paging for pipe compatibility if needed
      # Or just 'bat' if you always want its pager
      k = "kubectl"; # could tell that was gonna get annoying fast

      # Other useful aliases
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
    };

    # These settings require installing the packages listed in home.packages below
    autosuggestion.enable = true; # Suggest commands as you type (from history)
    syntaxHighlighting.enable = true; # Highlight commands and syntax in the terminal
    enableCompletion = true; # Enable Zsh's built-in completion system
    initContent = ''
      # Build KUBECONFIG from any kube config files that actually exist
      _kubeconfig=""
      for _f in "$HOME/.kube/config" "$HOME/.kube/k3s-pi.yaml"; do
        [ -f "$_f" ] && _kubeconfig="''${_kubeconfig:+$_kubeconfig:}$_f"
      done
      [ -n "$_kubeconfig" ] && export KUBECONFIG="$_kubeconfig"
      unset _kubeconfig _f

      # Add bun to PATH
      export PATH="$HOME/.bun/bin:$PATH"
    '';

    # Set history options
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history"; # Store history in XDG compliant location
    };
  };

}

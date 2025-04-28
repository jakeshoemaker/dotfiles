# ~/dotfiles/home-manager/common/git.nix
{ pkgs, ... }:

{
  # Enable Git configuration via Home Manager
  programs.git = {
    enable = true;

    # --- Essential Settings ---
    userName = "jake shoemaker";
    userEmail = "jakeshoe3@gmail.com";

    # --- Optional but Common Settings (Uncomment and modify as needed) ---

    # Set default branch name for new repositories
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };


    # Git Aliases (you can also define these in Zsh/Bash, but here is another option)
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };

    # Exclude global gitignore file (managed separately below if needed)
    # excludesFile = "~/.gitignore_global";
  };

  # Optional: Manage a global gitignore file
  home.file.".gitignore_global" = {
    text = ''
      # Ignore common files
      .DS_Store
      *.pyc
      __pycache__/
      .env
    '';
  };

  # Ensure Git itself is installed (already covered by common/default.nix but safe over sorry)
  home.packages = with pkgs; [
    git 
    gh    # github cli
    glab  # gitlab cli
  ];
}

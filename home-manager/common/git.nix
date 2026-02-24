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

    ignores = [
      ".DS_Store"
      "*.pyc"
      "__pycache__/"
      ".env"
    ];
  };

  home.packages = with pkgs; [
    gh    # github cli
    glab  # gitlab cli
  ];
}

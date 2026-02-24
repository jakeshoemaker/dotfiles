# ~/dotfiles/home-manager/common/tmux.nix
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Use C-a as prefix (easier to reach than C-b)
    prefix = "C-a";
    # Send C-a to nested sessions with C-a C-a
    extraConfig = ''
      bind C-a send-prefix
    '';

    # Mouse support
    mouse = true;

    # Start windows and panes at 1, not 0
    baseIndex = 1;

    # Use vi keys in copy mode
    keyMode = "vi";

    # Faster key repetition
    escapeTime = 0;

    # Increase scrollback buffer
    historyLimit = 10000;

    # Status bar refresh every second
    aggressiveResize = true;

    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible          # Sensible defaults
      yank              # System clipboard yanking (y in copy mode)
      {
        plugin = resurrect;  # Save/restore sessions
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;  # Auto-save sessions every 15 min
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
  };
}

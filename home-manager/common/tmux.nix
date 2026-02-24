# ~/dotfiles/home-manager/common/tmux.nix
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Use C-a as prefix (easier to reach than C-b)
    prefix = "C-a";

    # Mouse support
    mouse = true;

    # Start windows and panes at 1, not 0
    baseIndex = 1;

    # Use vi keys in copy mode — mirrors nvim's modal editing
    keyMode = "vi";

    # Faster key repetition / no escape delay (critical for nvim inside tmux)
    escapeTime = 0;

    # Increase scrollback buffer
    historyLimit = 10000;

    aggressiveResize = true;

    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible         # Sensible defaults
      yank             # System clipboard yanking (y in copy mode)
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

    extraConfig = ''
      # ── Prefix passthrough ────────────────────────────────────────────────
      bind C-a send-prefix

      # ── Pane navigation: C-h/j/k/l mirrors nvim window nav ───────────────
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R

      # ── Pane splitting: | for vertical, - for horizontal ─────────────────
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # New windows open in current path
      bind c new-window -c "#{pane_current_path}"

      # ── Copy mode: mirror nvim visual mode ────────────────────────────────
      # v  → begin selection     (nvim: v)
      # C-v → block selection    (nvim: C-v)
      # y  → yank selection      (nvim: y)  — yank plugin handles clipboard
      bind -T copy-mode-vi v   send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y   send -X copy-selection-and-cancel

      # ── Reload config ─────────────────────────────────────────────────────
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
    '';
  };
}

# Shell behavior
setopt auto_cd
setopt interactive_comments
setopt hist_ignore_dups
setopt share_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# Path helpers
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Better defaults
export EDITOR="${EDITOR:-nvim}"
export PAGER="less"
export LESS="-R"

# Tool integrations, if installed
command -v starship >/dev/null && eval "$(starship init zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# fzf keybindings/completion from Homebrew
if command -v brew >/dev/null; then
  FZF_PREFIX="$(brew --prefix fzf 2>/dev/null)"
  [ -r "$FZF_PREFIX/shell/key-bindings.zsh" ] && source "$FZF_PREFIX/shell/key-bindings.zsh"
  [ -r "$FZF_PREFIX/shell/completion.zsh" ] && source "$FZF_PREFIX/shell/completion.zsh"
fi

# Aliases
if command -v eza >/dev/null && eza --version >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -la --group-directories-first'
else
  alias ls='command ls'
  alias ll='command ls -la'
fi
alias grep='grep --color=auto'
alias cat='bat --paging=never 2>/dev/null || command cat'


autoload -Uz compinit && compinit
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Configure stow symlinks across system
cd ~/dotfiles

# Nixos
sudo stow -t /etc/nixos nixos

# Neovim
stow -t ~/.config/nvim nvim

# Hyprland
stow -t ~/.config/hypr hypr

# Waybar
stow -t ~/.config/waybar waybar

# rebuild nixos system configuration
sudo nixos-rebuild switch --flake .#nixos --impure

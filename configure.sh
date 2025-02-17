# Configure stow symlinks across system
cd ~/dotfiles


# rebuild system from dotfiles/nixos: 
# `sudo nixos-rebuild switch --flake .#nixos --impure`
sudo stow -t /etc/nixos nixos

stow -t ~/.config/nvim nvim

# rebuild nixos system configuration
sudo nixos-rebuild switch --flake .#nixos --impure

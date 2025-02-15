# Configure stow symlinks across system
cd ~/dotfiles

sudo stow -t /etc/nixos nixos

stow -t ~/.config/nvim nvim

#! /usr/bin/bash

# script that copies my dotfiles and pushes them to my gh repo
dotfiles_dir=/home/jakes/src/repos/dotfiles
branch=date +%s 
echo $branch

# create a new branch - today from epoch
# git fetch --progress
# git checkout -b $date +%s origin/main

# init.vim 
rm $dotfiles_dir/neovim/init.vim
cp /home/jakes/.config/nvim/init.vim $dotfiles_dir/neovim/

# i3
rm -r $dotfiles_dir/i3/
cp -r /home/jakes/.config/i3 $dotfiles_dir/i3

# alacritty
rm -r $dotfiles_dir/alacritty/.alacritty.yml
cp /home/jakes/.alacritty.yml $dotfiles_dir/alacritty/

# git add .
# git push origin/main # push like a mad lad

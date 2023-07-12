#!/bin/bash

sudo wget -c https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
sudo tar -xzvf nvim-linux64.tar.gz -C /opt

echo 'alias nvim=/opt/nvim-linux64/bin/nvim' >> ~/.bashrc
source ~/.bashrc

nvim --version

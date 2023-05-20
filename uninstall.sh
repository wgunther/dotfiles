#!/usr/bin/bash

rm ~/.config/nvim/init.vim
rm ~/.local/nvim.appimage
rm ~/.zshrc
rm ~/.bash_profile
rm -R -f ~/.local/share/nvim
mv ~/.bash_profile.bak ~/.bash_profile
mv ~/.zshrc.bak ~/.zshrc

sudo apt-get --assume-yes remove npm

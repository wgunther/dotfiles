#!/usr/bin/env zsh

rm ~/.config/nvim/init.vim
rm ~/.local/nvim.appimage
rm ~/.local/nvim
rm ~/.zshrc
rm ~/.bash_profile
rm -R -f ~/.local/share/nvim
rm -R -f ~/.local/squashfs-root
mv ~/.bash_profile.bak ~/.bash_profile
mv ~/.zshrc.bak ~/.zshrc

sudo apt-get --assume-yes remove npm

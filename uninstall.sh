#!/usr/bin/env zsh

rm ~/.config/nvim/init.vim
rm ~/.local/nvim.appimage
rm ~/.local/nvim
rm ~/.tmux.conf
rm ~/.local/gs

rm -R -f ~/.local/share/nvim
rm -R -f ~/.local/squashfs-root

rm ~/.zshrc
rm ~/.bashrc
mv ~/.bashrc.bak ~/.bashrc
mv ~/.zshrc.bak ~/.zshrc

sudo apt-get --assume-yes remove npm
git config --global --unset alias.undo

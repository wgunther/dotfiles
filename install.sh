#!/usr/bin/bash
sudo apt-get --assume-yes install npm

# Copy files out to where they are supposed to be
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim


# Download neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
mv nvim.appimage ~/.local/nvim.appimage

# Set up files
touch ~/.bash_profile
touch ~/.zshrc
cp ~/.bash_profile ~/.bash_profile.bak
cp ~/.zshrc ~/.zshrc.bak

# For consistency, I want to add to .bashrc and .zshrc, so
# Just add to .bash_profile and source it from .zshrc
echo 'source ~/.bash_profile' >> ~/.zshrc

# Add neovim
echo 'alias nvim=~/.local/nvim.appimage' >> ~/.bash_profile
echo 'alias vim=nvim' >> ~/.bash_profile

# Install plugins
~/.local/nvim.appimage --headless +qall
~/.local/nvim.appimage --headless +PlugInstall +qall

# Source to get neovim alias
source ~/.zshrc


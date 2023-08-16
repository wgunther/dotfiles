#!/usr/bin/env zsh
sudo apt-get --assume-yes install npm
yes | sudo cpan Perl::Tidy

# Copy files out to where they are supposed to be
mkdir -p ~/.config/nvim
ln -s $PWD/init.vim ~/.config/nvim/init.vim
ln -s $PWD/tmux.conf ~/.tmux.config
ln -s $PWD/gs ~/.local/gs

# Download neovim
mkdir -p ~/.local
cd ~/.local
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract
ln -s squashfs-root/usr/bin/nvim nvim
cd -

# Set up files
touch ~/.bash_profile
touch ~/.zshrc
cp ~/.bash_profile ~/.bash_profile.bak
cp ~/.zshrc ~/.zshrc.bak
# move editorconfig file to workspace root.
ln -s $PWD/.editorconfig /workspaces/.editorconfig

# For consistency, I want to add to .bashrc and .zshrc, so
# Just add to .bash_profile and source it from .zshrc
echo 'source ~/.bash_profile' >> ~/.zshrc

# Add neovim
echo 'alias nvim=~/.local/nvim' >> ~/.bash_profile
echo 'alias gs=~/.local/gs' >> ~/.bash_profile
echo 'alias vim=nvim' >> ~/.bash_profile

# Install plugins
~/.local/nvim --headless +qall
~/.local/nvim --headless +PlugInstall +qall

# Source to get neovim alias
source ~/.zshrc

# Git Aliases
git config --global alias.undo 'reset --soft HEAD^'

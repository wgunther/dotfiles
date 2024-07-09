#!/usr/bin/env zsh
sudo apt-get --assume-yes install npm
yes | sudo cpan Perl::Tidy

# Copy files out to where they are supposed to be
mkdir -p ~/.config/nvim
ln -s $PWD/init.vim ~/.config/nvim/init.vim
ln -s $PWD/tmux.conf ~/.tmux.conf
mkdir -p ~/.local
ln -s $PWD/gs ~/.local/gs
ln -s $PWD/xl ~/.local/xl

# Download neovim
cd ~/.local
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract
ln -s squashfs-root/usr/bin/nvim nvim

wget https://github.com/martinvonz/jj/releases/download/v0.19.0/jj-v0.19.0-x86_64-unknown-linux-musl.tar.gz
tar -zxvf jj-v0.19.0-x86_64-unknown-linux-musl.tar.gz ./jj
mkdir -p ~/.local/bin
mv jj ~/.local/bin
rm jj-*
cd -

# Set up files
touch ~/.bashrc
touch ~/.zshrc
# Backup
cp ~/.zshrc ~/.zshrc.bak
cp ~/.bashrc ~/.bashrc.bak
# Add alias file
VAR="source $PWD/aliases.sh"
echo $VAR
echo $VAR >> ~/.zshrc
echo $VAR >> ~/.bashrc

# move editorconfig file to workspace root.
ln -s $PWD/.editorconfig /workspaces/.editorconfig

# if pip is installed, then install neovim-remote
if command -v pip3 &> /dev/null
then
    pip3 install neovim-remote
fi

# Source to get neovim alias
source ~/.zshrc
source ~/.bashrc

# Install plugins
~/.local/nvim --headless +qall
~/.local/nvim --headless +PlugInstall +qall


#!/usr/bin/env zsh
sudo apt-get --assume-yes install npm
yes | sudo cpan Perl::Tidy

# Copy files out to where they are supposed to be
mkdir -p ~/.config/nvim
mkdir -p ~/.config/jj
ln -s $PWD/init.vim ~/.config/nvim/init.vim
ln -s $PWD/tmux.conf ~/.tmux.conf
ln -s $PWD/jj-config.toml ~/.config/jj/config.toml
mkdir -p ~/.local
ln -s $PWD/gs ~/.local/gs
ln -s $PWD/xl ~/.local/xl

# Download neovim
cd ~/.local
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage --appimage-extract
ln -s squashfs-root/usr/bin/nvim nvim

wget https://github.com/martinvonz/jj/releases/download/v0.23.0/jj-v0.23.0-x86_64-unknown-linux-musl.tar.gz
tar -zxvf jj-v0.23.0-x86_64-unknown-linux-musl.tar.gz ./jj
mkdir -p ~/.local/bin
mv jj ~/.local/bin
rm jj-*
cd -

# Set up jj environment
pushd "/workspaces/${RepositoryName}"
GIT_REMOTE=$(git remote)
export GIT_MAIN=$(git remote show "${GIT_REMOTE}" | sed -n '/HEAD branch/s/.*: //p')
envsubst '$GIT_MAIN' < "${JJ_BASE_CONFIG}" >> ~/.config/jj/config.toml
jj git init --colocate
# This branch tracking happens to work, but makes naming assumptions about refs.
jj branch track $(git branch --format="%(upstream:lstrip=-1)@${GIT_REMOTE}")
popd

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

# Install node 18 -- important for Copilot plugin
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.zshrc
nvm install 18

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


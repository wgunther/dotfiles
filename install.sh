#!/usr/bin/env zsh
sudo apt-get --assume-yes install npm
yes | sudo cpan Perl::Tidy

# Copy files out to where they are supposed to be
sudo mkdir -p ~/.config/nvim
sudo mkdir -p ~/.config/jj
sudo ln -s $PWD/init.vim ~/.config/nvim/init.vim
sudo ln -s $PWD/tmux.conf ~/.tmux.conf
sudo ln -s $PWD/jj-config.toml ~/.config/jj/config.toml
sudo mkdir -p ~/.local
sudo ln -s $PWD/gs ~/.local/gs
sudo ln -s $PWD/xl ~/.local/xl

# Use ecr-login for docker credentials
sudo mkdir -p ~/.docker
echo '{ "credsStore": "ecr-login" }' > ~/.docker/config.json


sudo mkdir -p ~/.local/bin

# Download neovim
cd ~/.local
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.3/nvim.appimage
chmod +x nvim.appimage
./nvim.appimage  --appimage-extract
sudo ln -s squashfs-root/usr/bin/nvim nvim
sudo ln -s ~/.local/nvim ~/.local/bin/nvim
sudo ln -s ~/.local/nvim ~/.local/bin/vim

# Install jj
sudo wget https://github.com/martinvonz/jj/releases/download/v0.24.0/jj-v0.24.0-x86_64-unknown-linux-musl.tar.gz
sudo tar -zxvf jj-v0.24.0-x86_64-unknown-linux-musl.tar.gz ./jj
sudo mv jj ~/.local/bin
sudo rm jj-*
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
#

# Install node 20 -- important for Copilot plugin
sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.zshrc
nvm install 20

# move editorconfig file to workspace root.
sudo ln -s $PWD/.editorconfig /workspaces/.editorconfig

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

# Set up jj environment
pushd "/workspaces/${RepositoryName}"
GIT_REMOTE=$(git remote)
export GIT_MAIN=$(git remote show "${GIT_REMOTE}" | sed -n '/HEAD branch/s/.*: //p')
envsubst '$GIT_MAIN' < "${JJ_BASE_CONFIG}" >> ~/.config/jj/config.toml
jj git init --colocate
# This branch tracking happens to work, but makes naming assumptions about refs.
jj branch track $(git branch --format="%(upstream:lstrip=-1)@${GIT_REMOTE}")
popd

# Set up git environment
git config --global credential.helper /.codespaces/bin/gitcredential_github.sh


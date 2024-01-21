#!/bin/bash

sudo apt update -y
sudo apt install -y gcc make tmux fish zip fzf
# for nvim
sudo apt install -y libfuse2

chsh -s "$(which tmux)"

wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

cd $HOME/workspace
git clone https://github.com/jiro4989/dotfiles
cd dotfiles
./setup.sh

wget https://github.com/x-motemen/ghq/releases/download/v1.4.2/ghq_linux_amd64.zip
unzip ghq_linux_amd64.zip
sudo install -m 0755 ghq_linux_amd64/ghq /usr/local/bin/ghq
rm -rf ghq_linux_amd64 ghq_linux_amd64.zip

NODENV_DIR="$HOME/.nodenv"
git clone https://github.com/nodenv/nodenv.git "$NODENV_DIR"
cd "$NODENV_DIR" && src/configure && make -C src
mkdir -p "$NODENV_DIR"/plugins
git clone https://github.com/nodenv/node-build.git "$NODENV_DIR"/plugins/node-build
PREFIX=/usr/local "$NODENV_DIR"/plugins/node-build/install.sh

fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source'
fish -c "fisher install jorgebucaran/fisher"
fish -c "fisher install edc/bass"
fish -c "fisher install oh-my-fish/theme-clearance"
fish -c "fisher install fisherman/z"

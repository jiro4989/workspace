#!/bin/bash

set -eu

add-apt-repository -y ppa:lazygit-team/release
add-apt-repository -y ppa:cwchien/gradle

apt-get update -yqq
apt-get install -y \
  build-essential \
  ca-certificates \
  ctags \
  curl \
  docker.io \
  fish \
  git \
  gradle \
  lazygit \
  peco \
  python3 \
  python3-pip \
  tmux \
  unzip \
  vim \
  wget \
  ;

add-apt-repository -y ppa:git-core/ppa
apt-get install -y git

# docker-compoes
curl -sL "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /tmp/docker-compose
install -o root -g root -m 0755 /tmp/docker-compose /usr/local/bin/docker-compose

cat << EOS > /tmp/init_vagrant_user.sh

# Vim
curl -sSf https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/install_dein.sh
bash /tmp/install_dein.sh ~/.cache/dein

# Git
git config --global user.email jiroron666@gmail.com
git config --global user.name jiro4989
git config --global ghq.root ~/src
git config --global alias.preq pull-request
git config --global alias.see browse

# Nim
curl https://nim-lang.org/choosenim/init.sh -sSf > /tmp/init.sh
sh /tmp/init.sh -y >/dev/null 2>&1

# dotfiles
git clone https://github.com/jiro4989/dotfiles
pushd dotfiles
./setup.sh

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c "fisher add edc/bass"
fish -c "fisher add oh-my-fish/theme-clearance"
fish -c "fisher add fisherman/z"

EOS

# Neovim
curl -sSfL https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage > /usr/local/bin/nvim
chmod 0755 /usr/local/bin/nvim

chmod +x /tmp/init_vagrant_user.sh
sudo -u vagrant -i /tmp/init_vagrant_user.sh

# docker
usermod -a -G docker vagrant

# change shell
chsh -s $(which tmux) vagrant

# fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# ssh
for f in id_rsa id_rsa.pub jiro4989 jiro4989.pub config; do
  install -o vagrant -g vagrant -m 0600 /home/vagrant/.host.ssh/$f /home/vagrant/.ssh/$f
done

# ghq
curl -sSL https://github.com/x-motemen/ghq/releases/download/v1.1.0/ghq_linux_amd64.zip > /tmp/ghq_linux_amd64.zip
pushd /tmp
unzip /tmp/ghq_linux_amd64.zip
install -m 0755 ghq_linux_amd64/ghq /usr/local/bin/ghq

# shfmt
curl -sSfL https://github.com/mvdan/sh/releases/download/v3.0.1/shfmt_v3.0.1_linux_amd64 > /usr/local/bin/shfmt
chmod +x /usr/local/bin/shfmt

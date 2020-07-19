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
  npm \
  peco \
  python3 \
  python3-pip \
  tmux \
  unzip \
  vim \
  wget \
  xsel \
  xvfb \
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
pip3 install --user pynvim

# Git
git config --global user.email jiroron666@gmail.com
git config --global user.name jiro4989
git config --global ghq.root ~/src
git config --global alias.preq pull-request
git config --global alias.see browse

# Nim
curl https://nim-lang.org/choosenim/init.sh -sSf > /tmp/init.sh
sh /tmp/init.sh -y >/dev/null 2>&1

export PATH=\$PATH:\$HOME/.nimble/bin
nimble install -Y inim

# dotfiles
git clone https://github.com/jiro4989/dotfiles
pushd dotfiles
./setup.sh

# fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c "fisher add edc/bass"
fish -c "fisher add oh-my-fish/theme-clearance"
fish -c "fisher add fisherman/z"

pip3 install --user virtualenv

repos=(
  jiro4989/infra
  jiro4989/websh
  jiro4989/nimbot
  jiro4989/workspace
  jiro4989/sandbox
  jiro4989/at_coder_note
)
for r in \${repos[@]}; do
  # ghw getできない
  : ghq get -p "\$r"
done

# rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

mkdir -p ~/bin

# mmv
(
  cd /tmp
  wget https://github.com/itchyny/mmv/releases/download/v0.1.1/mmv_v0.1.1_linux_amd64.tar.gz
  tar xzf ./mmv*.tar.gz
  install -m 0755 ./mmv*/mmv ~/bin/mmv
)

# direnv
(
  wget https://github.com/direnv/direnv/releases/download/v2.21.3/direnv.linux-amd64
  install -m 0755 ./direnv* ~/bin/direnv
)

EOS

# Neovim
curl -sSfL https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage > /usr/local/bin/nvim
chmod 0755 /usr/local/bin/nvim

# ssh
cp -r /home/vagrant/.host.ssh/conf.d /home/vagrant/.ssh/
chmod 0600 /home/vagrant/.ssh/conf.d/*
chmod 0700 /home/vagrant/.ssh/conf.d
chown -R vagrant:vagrant /home/vagrant/.ssh/conf.d

# ghq
curl -sSL https://github.com/x-motemen/ghq/releases/download/v1.1.0/ghq_linux_amd64.zip > /tmp/ghq_linux_amd64.zip
pushd /tmp
unzip /tmp/ghq_linux_amd64.zip
install -m 0755 ghq_linux_amd64/ghq /usr/local/bin/ghq

# shfmt
curl -sSfL https://github.com/mvdan/sh/releases/download/v3.0.1/shfmt_v3.0.1_linux_amd64 > /usr/local/bin/shfmt
chmod +x /usr/local/bin/shfmt

# user setup
chmod +x /tmp/init_vagrant_user.sh
sudo -u vagrant -i /tmp/init_vagrant_user.sh

# docker
usermod -a -G docker vagrant

# change shell
chsh -s $(which tmux) vagrant

# fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# bazel
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
apt update -yqq && apt install -y bazel

# gh
curl -sSfL https://github.com/cli/cli/releases/download/v0.10.0/gh_0.10.0_linux_amd64.deb > /tmp/gh_0.10.0_linux_amd64.deb
apt install -y /tmp/gh_*_linux_amd64.deb

# go
wget https://golang.org/dl/go1.14.6.linux-amd64.tar.gz
tar -C /usr/local xzf go1.14.6.linux-amd64.tar.gz


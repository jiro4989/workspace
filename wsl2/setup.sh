#!/bin/bash

set -eux

sudo apt-get update -yqq
sudo apt-get upgrade -yqq
sudo apt-get install -yqq \
  ca-certificates \
  wget \
  git

# 作業環境リポジトリを取得
cd ~
if [ ! -d workspace ]; then
  git clone https://github.com/jiro4989/workspace
fi

# 古いdockerを削除
sudo apt-get remove -y docker || true
sudo apt-get remove -y docker.io containerd runc || true
sudo apt-get remove -y containerd runc || true
sudo apt-get remove -y runc || true

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# sudoなしでdockerコマンドを実行できるようにする
sudo usermod -a -G docker jiro4989

# iptables-legacy に切り替える (手動)
sudo update-alternatives --config iptables

# Ubuntu起動時にdockerサービスを起動する
cat << EOS | sudo tee /etc/wsl.conf
[boot]
command="service docker start"
EOS

# docker daemonを起動する
sudo service docker start
sudo service docker status
sleep 1

# 動作確認
docker --version

#!/bin/bash

set -eux

sudo apt-get update -yqq
sudo apt-get upgrade -yqq
sudo apt-get install -yqq \
  ca-certificates \
  docker.io \
  wget \
  git
sudo usermod -a -G docker jiro4989

cd ~
if [ ! -d workspace ]; then
  git clone https://github.com/jiro4989/workspace
fi

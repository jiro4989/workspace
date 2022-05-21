#!/bin/bash

set -eux

apt-get update -yqq
apt-get upgrade -yqq
apt-get install -yqq \
  ca-certificates \
  wget \
  git

cd ~
if [ ! -d workspace ]; then
  git clone https://github.com/jiro4989/workspace
fi

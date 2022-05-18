#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt-get update -yqq

# GUI環境の構築
apt-get install -y lxde xvfb

# sdl2
apt-get install -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev

# freeglut
apt-get install -y freeglut3 freeglut3-dev

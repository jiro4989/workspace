#!/bin/bash

set -eu

# GUI環境の構築
apt-get install -y ubuntu-desktop

cd /tmp

# Java 14
curl -O https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz
tar xvf openjdk-14_linux-x64_bin.tar.gz

# OpenJFX 14
curl -o openjfx-14.0.1_linux-x64_bin-sdk.zip https://download2.gluonhq.com/openjfx/14.0.1/openjfx-14.0.1_linux-x64_bin-sdk.zip
unzip openjfx-14.0.1_linux-x64_bin-sdk.zip

mkdir -p /opt/java
mv jdk-14 /opt/java/
ln -sfn /opt/java/jdk-14 /opt/java/current

# sdl2
apt-get install -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-net-dev libsdl2-ttf-dev

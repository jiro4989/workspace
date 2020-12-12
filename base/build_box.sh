#!/bin/bash

set -eux

readonly box_name="jiro4989/base-ubuntu-20.04-$(date +%Y%m%d)"

vagrant destroy -f
vagrant up
rm -f package.box || true
vagrant package
vagrant box add -f "$box_name" package.box
vagrant halt

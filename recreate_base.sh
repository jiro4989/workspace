#!/bin/bash

set -eux

(
	cd base
	vagrant destroy -f
	vagrant up
	rm -f package.box || true
	vagrant package
	vagrant box add -f "jiro4989/base-ubuntu-20.04" package.box
	vagrant halt
)

(
	cd base-gui
	vagrant destroy -f
	vagrant up
	rm -f package.box || true
	vagrant package
	vagrant box add -f "jiro4989/base-gui-ubuntu-20.04" package.box
	vagrant halt
)

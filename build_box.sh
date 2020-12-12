#!/bin/bash

set -eu

if [[ $# -eq 0 ]]; then
	echo "第1引数は必須です。" >&2
	echo "example: $0 base"
	exit 1
fi

set -x

readonly target_dir=$1
readonly box_name="jiro4989/$target_dir-ubuntu-20.04-$(date +%Y%m%d)"

vagrant destroy -f
vagrant up
rm -f package.box || true
vagrant package
vagrant box add -f "$box_name" package.box
vagrant halt

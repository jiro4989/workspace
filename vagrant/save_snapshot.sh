#!/bin/bash

set -eu

if [[ $# -eq 0 ]]; then
	echo "第1引数は必須です。" >&2
	echo "example: $0 base"
	exit 1
fi

set -x

readonly target_dir=$1

cd "$target_dir"
vagrant snapshot save `date +%Y-%m-%d`
vagrant snapshot list

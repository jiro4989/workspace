#!/bin/bash

set -eu

err() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [ERR] $*" >&2
}

check_envrc_param() {
  local param
  param="$1"
  if grep "${param}=xxxxx" .envrc; then
    err "初期値の${param}はNGです。変更してください"
    exit 1
  fi
}

if [ ! -f ~/.netrc ]; then
  err "$HOME/.netrc を作成してください"
  exit 1
fi

if [ ! -f .envrc ]; then
  err ".envrc を作成してください"
  exit 1
fi

check_envrc_param PASSWORD
check_envrc_param EMAIL

#!/bin/bash

set -eu

if [ ! -f ~/.netrc ]; then
  echo "[ERR] ~/.netrc を作成してください"
  exit 1
fi

if [ ! -f .envrc ]; then
  echo "[ERR] .envrc を作成してください"
  exit 1
fi

#!/bin/bash

set -eu

usage() {
  cat << EOS >&2
usage:
  setup.sh
  setup.sh <target_dir>
  setup.sh all
EOS
}

build_save() {
  local dir=$1
  if [[ ! -d "$dir" ]]; then
    echo "[ERR] ディレクトリが存在しません" >&2
    usage
    return 1
  fi

  ./build_box.sh "$dir"
  ./save_snapshot.sh "$dir"
}

if (($# < 1)); then
  usage
  exit 1
fi

case "$1" in
  all)
    for dir in ubuntu-20.04 ubuntu-20.04-gui; do
      build_save "$dir"
    done
    ;;
  *)
    build_save "$1"
    ;;
esac

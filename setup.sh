#!/bin/bash

set -eu

for dir in ubuntu-20.04 ubuntu-20.04-gui; do
  ./build_box.sh "$dir"
  ./save_snapshot.sh "$dir"
done

#!/bin/bash

set -eux

for d in base base-gui; do
  (
    cd "$d"
    vagrant destroy -f
    vagrant up
    rm -f package.box || true
    vagrant package
    vagrant box add -f "jiro4989/$d" package.box
    vagrant halt
  )
done


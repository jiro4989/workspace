#!/bin/bash

set -eu

for d in base base-gui; do
  (
    cd "vagrant/$d"
    vagrant init
    vagrant up
    vagrant package
    vagrant box add "jiro4989/$d" package.box
    vagrant halt
  )
done

for d in main main-gui; do
  (
    cd "vagrant/$d"
    vagrant init
    vagrant up
    vagrant halt
  )
done

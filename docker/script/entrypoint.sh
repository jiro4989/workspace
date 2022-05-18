#!/bin/bash

set -eux

# Fishプラグインをセットアップ
fish -c "fisher install edc/bass"
fish -c "fisher install oh-my-fish/theme-clearance"
fish -c "fisher install fisherman/z"

exec tmux

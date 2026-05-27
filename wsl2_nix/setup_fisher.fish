#!/usr/bin/env fish

function exists_plugin
  if fisher list | grep -F $argv[1] >/dev/null
    return 0
  end
  return 1
end

function install_plugin
  if ! exists_plugin $argv[1]
    fisher install $argv[1]
    return 0
  end

  echo "$argv[1] exists. installation was skipped"
  return 0
end

if ! type fisher >/dev/null
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/791da644d33d392216f6b1a9b5fc1e470db6d7f2/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

install_plugin edc/bass
install_plugin fisherman/z

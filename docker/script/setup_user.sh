#!/bin/bash

set -eu

groupadd --gid "${LOCAL_GID}" "${WORKUSER}"
useradd -m \
  --uid "${LOCAL_UID}" \
  --gid "${LOCAL_GID}" \
  -d "/home/${WORKUSER}" \
  -s "$(command -v tmux)" \
  "${WORKUSER}"
echo "${WORKUSER}:${PASSWORD}" | chpasswd
gpasswd -a "${WORKUSER}" docker
echo "%${WORKUSER}    ALL=(ALL)   NOPASSWD:    ALL" >> "/etc/sudoers.d/${WORKUSER}"
chmod 0440 "/etc/sudoers.d/${WORKUSER}"

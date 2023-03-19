#!/bin/bash
set -e

function apt_get_update() {
  if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
    echo "Running apt-get update..."
    apt-get update -y
  fi
}

function check_packages() {
  if ! dpkg -s "$@" > /dev/null 2>&1; then
    apt_get_update
    apt-get -yq install --no-install-recommends "$@"
  fi
}

function apt_clean() {
  apt-get clean autoclean
  apt-get autoremove -y
  rm -rf /var/lib/{apt,dpkg,cache,log}/
}

function install_starship() {
  mkdir -p /tmp
  curl -sS -o /tmp/starship.sh  https://starship.rs/install.sh
  chmod +x /tmp/starship.sh
  /tmp/starship.sh -y
}

export DEBIAN_FRONTEND=noninteractive
export TZ=Europe/London

check_packages "ca-certificates" "curl" "exa" "git" "gnupg" "locales" "openssh-client" "tmux" "tzdata" "vim" "zoxide" "zsh"
install_starship

echo "LC_ALL=en_GB.UTF-8" >> /etc/environment
echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
locale-gen en_GB.UTF-8

apt_clean

git clone https://github.com/willfantom/.files "${_CONTAINER_USER_HOME}/.files"
cd "${_CONTAINER_USER_HOME}/.files"
chmod +x setup.sh && ./setup.sh "${_CONTAINER_USER_HOME}"

chsh -s "$(which zsh)"

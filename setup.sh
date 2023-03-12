#!/usr/bin/env zsh
set -o errexit
set -o nounset
cd "$(dirname "$0")"

BASE_DIR="$(pwd)"
TARGET_DIR="${HOME}"

DOTFILES=()
DOTFILES+=('.zshrc')          #main rc file for zsh
DOTFILES+=('.zsh.d')          #directory containing files sourced by the zshrc
DOTFILES+=('.starship')       #configuration directory for the starship prompt
DOTFILES+=('.gitconfig')      #git configuration file
DOTFILES+=('.gitconfig.d')    #directory of files used by the gitconfig
DOTFILES+=('.mackup.cfg')     #main mackup configuration file
DOTFILES+=('.mackup')         #directory of application specific mackup configurations

function print_ok() {
  printf "✅\t\033[0;32m%s\033[0m\n" "${1}"
}

function print_warn() {
  printf "⚠️\t\033[0;33m%s\033[0m\n" "${1}"
}

function print_error() {
  printf "❌\t\033[0;31m%s\033[0m\n" "${1}"
}

function assert_command() {
  if ! command -v "${1}" > /dev/null 2>&1; then
    print_error "missing command: ${1}" && exit 1
  fi
}

function main() {
  assert_command "zsh"
  assert_command "git"
  assert_command "vim"
  assert_command "rm"
  assert_command "ln"
  assert_command "readlink"

  for dotfile in "${DOTFILES[@]}"; do

    if [[ -L "${TARGET_DIR}/${dotfile}" ]]; then 
      if [[ $(readlink "${TARGET_DIR}/${dotfile}") == "${BASE_DIR}/${dotfile}" ]]; then
        print_ok "link already exists: ${TARGET_DIR}/${dotfile}" && continue
      fi
    fi

    if [ -e "${TARGET_DIR}/${dotfile}" ]; then
      rm -r "${TARGET_DIR:?}/${dotfile:?}" || exit 1
      print_warn "removed file: ${TARGET_DIR}/${dotfile}"
    fi

    ln -s "${BASE_DIR}/${dotfile}" "${TARGET_DIR}/${dotfile}" || exit 1
    print_ok "linked file: ${TARGET_DIR}/${dotfile}"

  done
}

main "$@"

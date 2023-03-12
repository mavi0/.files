#!/usr/bin/env zsh

function source_aliases() {
  # Sources shell aliases from a file
  # ---
  # usage: source_aliases "<extension>"
  # note: the extension argument can be used to specify which alias files to source
  local aliases_dir="${HOME}/.zsh.d/aliases"
  if [[ -f "${aliases_dir}/aliases.${1}.sh" ]]; then
    source "${aliases_dir}/aliases.${1}.sh"
  fi
  unset aliases_dir
}

function source_functions() {
  # Sources shell functions from a file
  # ---
  # usage: source_functions "<extension>"
  # note: the extension argument can be used to specify which function files to source
  local functions_dir="${HOME}/.zsh.d/functions"
  if [[ -f "${functions_dir}/functions.${1}.sh" ]]; then
    source "${functions_dir}/functions.${1}.sh"
  fi
  unset functions_dir
}

function source_plugins() {
  # Sources zsh plugins from a file
  # ---
  # usage: source_plugins "<extension>"
  # note: the extension argument can be used to specify which plugin files to source
  local plugins_dir="${HOME}/.zsh.d/plugins"
  if [[ -f "${plugins_dir}/plugins.${1}.txt" ]]; then
    if [[ "${plugins_dir}/plugins.${1}.zsh" -ot "${plugins_dir}/plugins.${1}.txt" ]] || [[ ! -e "${plugins_dir}/plugins.${1}.zsh" ]]; then
      antidote bundle <${plugins_dir}/plugins.${1}.txt >${plugins_dir}/plugins.${1}.zsh 2> /dev/null
    fi
  fi
  if [[ -f "${plugins_dir}/plugins.${1}.zsh" ]]; then
    source "${plugins_dir}/plugins.${1}.zsh"
  fi
  unset plugins_dir
}

function source_rc() {
  # Source further rc logic
  # ---
  # usage: source_rc "<extension>"
  # note: the extension argument can be used to specify which rc files to source
  local rc_dir="${HOME}/.zsh.d"
  if [[ -f "${rc_dir}/${1}.sh" ]]; then
    source "${rc_dir}/${1}.sh"
  fi
  unset rc_dir
}

function source_path() {
  # Source path changes
  # ---
  # usage: source_path "<extension>"
  # note: the extension argument can be used to specify which path files to source
  local path_dir="${HOME}/.zsh.d"
  if [[ -f "${path_dir}/path.${1}.sh" ]]; then
    source "${path_dir}/path.${1}.sh"
  fi
  unset path_dir
}

function install_antidote() {
  # Installs the 'Anitdote' zsh framework
  # ---
  # usage: install_antidote "<version>"
  # note: this does not use any other local functions so it can be executed at the start of the zshrc
  local framework_dir
  framework_dir="${HOME}/.antidote"
  if ! [[ -e "$framework_dir" ]]; then
    if ! command -v "git" > /dev/null 2>&1; then
      printf "\033[0;31m%s\033[0m\n" "Git is required to install the antidote zsh framework!"
      return 1
    fi
    git clone --quiet --depth=1 https://github.com/mattmc3/antidote.git -b "${1}" "$framework_dir" || return 1
  fi
  source "${framework_dir}/antidote.zsh"
  autoload -Uz compinit
  compinit
  autoload -Uz "${framework_dir}/functions/antidote"
  unset framework_dir
}

function main() {
  local uname=$(uname | tr '[:upper:]' '[:lower:]')
  install_antidote "v1.8.1"           #setup zsh framework
  source_plugins "all"                #install general purpose plugins
  source_plugins "${uname}"           #install os specific plugins
  source_functions "all"              #install general purpose functions
  source_functions "${uname}"         #install os specific functions
  source_aliases "all"                #install general purpose aliases
  source_aliases "${uname}"           #install os specific aliases
  source_path "all"                   #install general purpose path changes
  source_path "${uname}"              #install os specific path changes
  source_rc "all"                     #install general purpose rc extras
  source_rc "${uname}"                #install os specific rc extras
  unset uname                         #cleanup
}

main "$@"

unset -f install_antidote
unset -f source_aliases
unset -f source_functions
unset -f source_plugins
unset -f source_path
unset -f source_rc
unset -f main
